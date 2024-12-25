#pragma once

#include <QtCore/QObject>

#include "SettingsManager.h"
#include "CloudResource.h"

namespace CloudSync
{
    class Cloud;
    class Directory;
}

class CloudManager : public QObject
{
    Q_OBJECT

public:
    explicit CloudManager( SettingsManager& settngs, QObject* parent = nullptr );

    static void qmlRegister();

public:
    bool Connect();
    void Disconnect();
    void UploadFile( const std::string& fileName, const std::vector<uint8_t>& content );

    Q_INVOKABLE QVariantList ListResources();

private:
    SettingsManager& mSettings;
    std::shared_ptr<CloudSync::Cloud> mCloud;
    std::shared_ptr<CloudSync::Directory> mCurrentDir;
};