#pragma once

#include <QtCore/QObject>

#include <QQmlConstRefPropertyHelpers.h>
#include <QQmlEnumClassHelper.h>

namespace CloudSync
{
    class Resource;
}

QSM_ENUM_CLASS( CloudFSItemType, Unknown = 0, Folder, File )

class CloudResource : public QObject
{
    Q_OBJECT
    QSM_READONLY_CSTREF_PROPERTY_WDEFAULT( CloudFSItemType::Type, type, Type, CloudFSItemType::Unknown )
    QSM_READONLY_CSTREF_PROPERTY_WDEFAULT( QString, name, Name, "" )

public:
    explicit CloudResource( QObject* parent = nullptr );
    explicit CloudResource( std::shared_ptr<CloudSync::Resource> res, QObject* parent = nullptr );
};

Q_DECLARE_METATYPE( CloudResource* )