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
    QSM_WRITABLE_CSTREF_PROPERTY(int, id, Id)  //Идентификатор действия
    QSM_WRITABLE_CSTREF_PROPERTY_WDEFAULT(QString, patternName, PatternName, "")  //Идентификатор действия
    QSM_READONLY_CSTREF_PROPERTY(QUuid, deviceId, DeviceId) //Идентификатор сопоставленного устройства
    QSM_READONLY_VAR_PROPERTY(qulonglong, startTime, startTime) //Время начала Action относительно стартовой позиции Cue
    QSM_READONLY_CSTREF_PROPERTY(QUuid, patternNumber, patternNumber) //Идентификатор присвоенного паттерна

public:
    explicit Action(QObject *parent = nullptr);
};
