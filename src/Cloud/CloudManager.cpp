#include <QDebug>
#include <QFuture>

#include "CloudManager.h"
#include "CloudResource.h"
#include "CloudParentDir.h"

#include "CloudSync/BasicCredentials.hpp"
#include "CloudSync/CloudFactory.hpp"
#include "CloudSync/exceptions/cloud/CloudException.hpp"
#include "CloudSync/exceptions/resource/ResourceException.hpp"
#include "CloudSync/Cloud.hpp"

constexpr char NEXTCLOUD_URL[] = "https://cloud.mainfx.ru/";

CloudManager::CloudManager( SettingsManager& settngs, QObject* parent /*= nullptr*/ )
    : mSettings( settngs )
    , QObject( parent )
{
    mCloudViewModel = new CloudViewModel( this );
    mConnectWatcher = new QFutureWatcher<bool>( this );

    QObject::connect( mConnectWatcher, &QFutureWatcher<bool>::finished, this, &CloudManager::connectWatcherFinished );
}

void CloudManager::qmlRegister()
{
    CloudFSItemType::registerToQml( "MFX.Enums", 1, 0 );
    CloudStateEnum::registerToQml( "MFX.Enums", 1, 0 );
    qRegisterMetaType<CloudResource*>( "CloudResource*" );
    qmlRegisterUncreatableType<QQmlObjectListModelBase>( "MFX.Models", 1, 0, "QQmlObjectListModelBase", "QQmlObjectListModelBase can not be created from QML" );
}

QQmlObjectListModelBase* CloudManager::cloudViewModel() const
{
    return mCloudViewModel;
}

void CloudManager::reconnect()
{
    Disconnect();
    Connect();
}

void CloudManager::Connect()
{
    if( cloudState() != CloudStateEnum::Disconnected )
        return;

    setCloudState( CloudStateEnum::Connecting );

    QFuture<bool> future = QtConcurrent::run( this, &CloudManager::doConnect );
    mConnectWatcher->setFuture( future );
}

bool CloudManager::doConnect()
{
    const auto login = mSettings.value( "cloudLogin" ).toString().toStdString();
    const auto password = mSettings.value( "cloudPassword" ).toString().toStdString();

    if( login.empty() || password.empty() )
        return false;

    try
    {
        auto credentials = CloudSync::BasicCredentials::from_username_password( login, password );
        mCloud = CloudSync::CloudFactory().create_nextcloud( NEXTCLOUD_URL, credentials );
        mCloud->test_connection();
    }
    catch( const CloudSync::exceptions::Exception& e )
    {
        qWarning() << "Sth went wrong: " << e.what();

        mCloud.reset();
        return false;
    }

    return true;
}

void CloudManager::connectWatcherFinished()
{
    setCloudState( mConnectWatcher->result() ? CloudStateEnum::Connected : CloudStateEnum::Disconnected );
}

void CloudManager::Disconnect()
{
    if( cloudState() == CloudStateEnum::Disconnected )
        return;

    setCloudState( CloudStateEnum::Disconnecting );

    try
    {
        if( mCloud )
            mCloud->logout();
    }
    catch( const CloudSync::exceptions::Exception& e )
    {
        qWarning() << "Sth went wrong: " << e.what();
    }

    mCloud.reset();

    setCurrentPath( "" );
    setCloudState( CloudStateEnum::Disconnected );
}

void CloudManager::UploadFile( QString fileName, const std::vector<uint8_t>& content )
{
    if( cloudState() != CloudStateEnum::Connected || !mCloud )
        return;

    try
    {
        if( !mCurrentDir )
            mCurrentDir = mCloud->root();

        fileName = QUrl::toPercentEncoding( fileName );

        try
        {
            auto file = mCurrentDir->get_file( fileName.toStdString() );
            file->remove();
        }
        catch( CloudSync::exceptions::resource::NoSuchResource& )
        {
        }

        auto file = mCurrentDir->create_file( fileName.toStdString() );
        file->write_binary( content );
    }
    catch( const CloudSync::exceptions::Exception& e )
    {
        qCritical() << "Sth went wrong: " << e.what();
        Disconnect();
    }
}

void CloudManager::changeCurrentDir( CloudResource* res )
{
    if( cloudState() != CloudStateEnum::Connected || !mCloud )
        return;

    std::shared_ptr<CloudSync::Resource> cloudRes = res ? res->mCloudRes : mCloud->root();
    std::shared_ptr<CloudSync::Directory> cloudDir = std::dynamic_pointer_cast<CloudSync::Directory>( cloudRes );

    if( !cloudDir )
        return;

    mCurrentDir = cloudDir;
    setCurrentPath( mCurrentDir->path().string().c_str() );

    RefreshCurrentDir();
}

void CloudManager::RefreshCurrentDir()
{
    if( cloudState() != CloudStateEnum::Connected || !mCloud )
        return;

    try
    {
        mCloudViewModel->clear();

        std::shared_ptr<CloudSync::Directory> cloudRoot = mCloud->root();

        if( mCurrentDir->path() == cloudRoot->path() )
            mCurrentDir = cloudRoot; // fix get_directory( ".." )
        else
            mCloudViewModel->append( new CloudParentDir( mCurrentDir->get_directory( ".." ) ) );

        for( auto& res : mCurrentDir->list_resources() )
            mCloudViewModel->append( new CloudResource( res ) );
    }
    catch( const CloudSync::exceptions::cloud::CloudException& e )
    {
        qCritical() << "Sth went wrong: " << e.what();
    }
}