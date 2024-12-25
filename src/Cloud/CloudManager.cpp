#include "CloudManager.h"
#include "CloudResource.h"

#include "CloudSync/BasicCredentials.hpp"
#include "CloudSync/CloudFactory.hpp"
#include "CloudSync/exceptions/cloud/CloudException.hpp"
#include "CloudSync/Cloud.hpp"

#include <QDebug>

constexpr char NEXTCLOUD_URL[] = "https://cloud.mainfx.ru/";

CloudManager::CloudManager( SettingsManager& settngs, QObject* parent /*= nullptr*/ )
    : mSettings( settngs )
    , QObject( parent )
{
}

void CloudManager::qmlRegister()
{
    CloudFSItemType::registerToQml( "MFX.Enums", 1, 0 );
    qRegisterMetaType<CloudResource*>( "CloudResource*" );
}

bool CloudManager::Connect()
{
    if( mCloud )
        return true;

    const auto login = mSettings.value( "cloudLogin" ).toString().toStdString();
    const auto password = mSettings.value( "cloudPassword" ).toString().toStdString();

    if( login.empty() || password.empty() )
        return false;

    try
    {
        auto credentials = CloudSync::BasicCredentials::from_username_password( login, password );
        mCloud = CloudSync::CloudFactory().create_nextcloud( NEXTCLOUD_URL, credentials );
    }
    catch( const CloudSync::exceptions::cloud::CloudException& e )
    {
        qCritical() << "Sth went wrong: " << e.what();
        return false;
    }

    return true;
}

void CloudManager::Disconnect()
{
    if( !mCloud )
        return;

    mCloud->logout();
    mCloud.reset();
}

void CloudManager::UploadFile( const std::string& fileName, const std::vector<uint8_t>& content )
{
    if( !Connect() )
        return;

    try
    {
        if( !mCurrentDir )
            mCurrentDir = mCloud->root();

        auto file = mCurrentDir->create_file( fileName );
        file->write_binary( content );
    }
    catch( const CloudSync::exceptions::cloud::CloudException& e )
    {
        qCritical() << "Sth went wrong: " << e.what();
    }
}

QVariantList CloudManager::ListResources()
{
    if( !Connect() )
        return {};

    try
    {
        if( !mCurrentDir )
            mCurrentDir = mCloud->root();

        QVariantList resources;

        for( auto& res : mCurrentDir->list_resources() )
            resources.append( QVariant::fromValue( new CloudResource( res ) ) );

        return resources;
    }
    catch( const CloudSync::exceptions::cloud::CloudException& e )
    {
        qCritical() << "Sth went wrong: " << e.what();
    }

    return {};
}