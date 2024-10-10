#pragma once

#include <QtCore/QObject>
#include <QtCore/QUuid>

#include <QSuperMacros.h>
#include <QQmlVarPropertyHelpers.h>
#include <QQmlConstRefPropertyHelpers.h>

class Action : public QObject
{
    Q_OBJECT

    QSM_READONLY_CSTREF_PROPERTY(QUuid, uuid, Uuid)  //Уникальный идентификатор действия
    QSM_WRITABLE_CSTREF_PROPERTY_WDEFAULT(QString, patternName, PatternName, "")  //Идентификатор действия
    QSM_READONLY_CSTREF_PROPERTY(int, deviceId, DeviceId) //Идентификатор сопоставленного устройства
    QSM_READONLY_CSTREF_PROPERTY(QUuid, deviceUuid, DeviceUuid) //Уникальный идентификатор сопоставленного устройства
    QSM_READONLY_VAR_PROPERTY(qulonglong, startTime, StartTime) //Время начала Action относительно стартовой позиции Cue

public:
    explicit Action(QObject *parent = nullptr);
};
