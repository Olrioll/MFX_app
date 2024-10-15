#pragma once

#include "Devices/SequenceDevice.h"

class PreviewDevice : public SequenceDevice
{
public:
    explicit PreviewDevice( DeviceManager* mng, QObject* parent = nullptr );

private:
    void setDMXOper( int deviceId, int duration, int angle, int velocity, int height, const QString& colorType, bool active ) override;
};