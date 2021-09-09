#pragma once

#include <QtCore/QObject>
#include <QtCore/QUuid>

#include <QQmlConstRefPropertyHelpers.h>
#include <QQmlEnumClassHelper.h>
#include <QQmlVarPropertyHelpers.h>
#include <QSuperMacros.h>

QSM_ENUM_CLASS(PatternType, Unknown = -1, Sequential = 0, Dynamic, Static)

class Operation: public QObject {
    Q_OBJECT
    QSM_WRITABLE_VAR_PROPERTY(int, time, Time)
    QSM_WRITABLE_VAR_PROPERTY(int, angle, Angle)
    QSM_WRITABLE_VAR_PROPERTY(int, velocity, Velocity)
    QSM_WRITABLE_VAR_PROPERTY(bool, fireOn, FireOn)
public:
    explicit Operation(QObject* parent = nullptr);
    Operation(const Operation& op);
    int angleDegrees();
};

class Pattern : public QObject {
    Q_OBJECT
    QSM_READONLY_CSTREF_PROPERTY(QUuid, uuid, Uuid)
    QSM_READONLY_CSTREF_PROPERTY_WDEFAULT(QString, name, Name, "")
    QSM_READONLY_CSTREF_PROPERTY_WDEFAULT(PatternType::Type, type, Type, PatternType::Unknown)
    QSM_READONLY_VAR_PROPERTY_WDEFAULT(qulonglong, duration, Duration, 0)
    QSM_READONLY_VAR_PROPERTY_WDEFAULT(qulonglong, prefireDuration, PrefireDurarion, 0)
public:
    explicit Pattern(QObject* parent = nullptr);
    QList<Operation> m_operationList;
};

Q_DECLARE_METATYPE(Pattern *)
