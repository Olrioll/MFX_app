#pragma once

#include <QQmlObjectListModel.h>
#include <QtConcurrent>

#include "SettingsManager.h"
#include "CloudResource.h"

namespace CloudSync
{
    class Cloud;
    class Directory;
}

using CloudViewModel = QQmlObjectListModel<CloudResource>;

QSM_ENUM_CLASS( CloudStateEnum, Disconnected = 0, Disconnecting, Connected, Connecting )

class CloudManager : public QObject
{
    Q_OBJECT
    QSM_READONLY_CSTREF_PROPERTY_WDEFAULT( QString, currentPath, CurrentPath, "" )
    QSM_READONLY_CSTREF_PROPERTY_WDEFAULT( CloudStateEnum::Type, cloudState, CloudState, CloudStateEnum::Disconnected )
    Q_PROPERTY( QQmlObjectListModelBase* cloudViewModel READ cloudViewModel CONSTANT )

public:
    explicit CloudManager( SettingsManager& settngs, QObject* parent = nullptr );

    static void qmlRegister();

    QQmlObjectListModelBase* cloudViewModel() const;

public:
    void Connect();
    void Disconnect();
    void UploadFile( QString fileName, const std::vector<uint8_t>& content );
    void RefreshCurrentDir();

    Q_INVOKABLE void reconnect();
    Q_INVOKABLE void changeCurrentDir( CloudResource* res );

private:
    bool doConnect();
    void connectWatcherFinished();

private:
    SettingsManager& mSettings;
    std::shared_ptr<CloudSync::Cloud> mCloud;
    std::shared_ptr<CloudSync::Directory> mCurrentDir;
    CloudViewModel* mCloudViewModel = nullptr;
    QFutureWatcher<bool>* mConnectWatcher;
};