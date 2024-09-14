#pragma once

#include "Device.h"

class ShotDevice : public Device
{
    Q_OBJECT
    QSM_WRITABLE_CSTREF_PROPERTY_WDEFAULT( QString, comPort, ComPort, "" ) //ComPort устройства
    QSM_WRITABLE_CSTREF_PROPERTY_WDEFAULT( QString, colorType, ColorType, "" )
    QSM_WRITABLE_VAR_PROPERTY_WDEFAULT( int, dmx, Dmx, 0 ) //DMX
    QSM_WRITABLE_VAR_PROPERTY_WDEFAULT( int, rfChannel, RfChannel, 0 ) //DMX
    QSM_WRITABLE_VAR_PROPERTY_WDEFAULT( int, rfPosition, RfPosition, 0 ) //DMX
    QSM_WRITABLE_VAR_PROPERTY_WDEFAULT( int, maxAngle, MaxAngle, 0 ) //DMX
    QSM_WRITABLE_VAR_PROPERTY_WDEFAULT( int, minAngle, MinAngle, 0 ) //DMX
    QSM_WRITABLE_VAR_PROPERTY_WDEFAULT( int, height, height, 0 ) //DMX

public:
    explicit ShotDevice( QObject* parent = nullptr );
};
