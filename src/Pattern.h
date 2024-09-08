#pragma once

#include <QtCore/QObject>
#include <QtCore/QUuid>

#include <QQmlConstRefPropertyHelpers.h>
#include <QQmlEnumClassHelper.h>
#include <QQmlVarPropertyHelpers.h>
#include <QSuperMacros.h>
#include "QQmlObjectListModel.h"

#include "Operation.h"

//QSM_ENUM_CLASS(PatternType, Unknown = -1, Sequential = 0, Dynamic, Static)
QSM_ENUM_CLASS( PatternType, Unknown = -1, Sequential = 0, Shot )

class Pattern : public QObject
{
    Q_OBJECT
    //QSM_READONLY_CSTREF_PROPERTY(QUuid, uuid, Uuid)
    QSM_READONLY_VAR_PROPERTY_WDEFAULT( uint, seq, Seq, 0 )
    QSM_READONLY_CSTREF_PROPERTY_WDEFAULT(QString, name, Name, "")
    QSM_READONLY_CSTREF_PROPERTY_WDEFAULT(PatternType::Type, type, Type, PatternType::Unknown)
    QSM_READONLY_VAR_PROPERTY_WDEFAULT(qulonglong, prefireDuration, PrefireDuration, 0)
    QML_OBJMODEL_PROPERTY(Operation, operations)

public:
    explicit Pattern( QObject* parent = nullptr );
    explicit Pattern( const QVariantMap& properies, QObject* parent = nullptr );

    void makeName();
    QVariantMap getProperties() const;
    void setProperties( const QVariantMap& properties );
};

Q_DECLARE_METATYPE(Pattern *)
