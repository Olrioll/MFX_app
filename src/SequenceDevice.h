#pragma once

#include <QtCore/QObject>
#include <QtCore/QUuid>

#include "QQmlObjectListModel.h"
#include <QQmlConstRefPropertyHelpers.h>
#include <QQmlVarPropertyHelpers.h>
#include <QSuperMacros.h>

#include "Device.h"

class SequenceDevice : public Device {
    Q_OBJECT
    //QSM_WRITABLE_VAR_PROPERTY_WDEFAULT(Device::ComPortWinOS, comPort, ComPort, Device::ComPortWinOS::COM_PORT_UNKNOWN) //ComPort устройства
    QSM_WRITABLE_CSTREF_PROPERTY_WDEFAULT(QString, comport, ComPort, "") //ComPort устройства
    QSM_WRITABLE_VAR_PROPERTY_WDEFAULT(int, dmx, Dmx, 0) //DMX
    QSM_WRITABLE_VAR_PROPERTY_WDEFAULT(int, rfChannel, RfChannel, 0) //DMX
    QSM_WRITABLE_VAR_PROPERTY_WDEFAULT(int, rfPosition, RfPosition, 0) //DMX
    QSM_WRITABLE_VAR_PROPERTY_WDEFAULT(int, maxAngle, MaxAngle, 0) //DMX
    QSM_WRITABLE_VAR_PROPERTY_WDEFAULT(int, minAngle, MinAngle, 0) //DMX
    QSM_WRITABLE_VAR_PROPERTY_WDEFAULT(int, height, height, 0) //DMX
public:
    explicit SequenceDevice(QObject* parent = nullptr);

    void runPattern(int num) override;
};
