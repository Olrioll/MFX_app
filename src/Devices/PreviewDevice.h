#pragma once

#include "Devices/SequenceDevice.h"

class PreviewDevice : public SequenceDevice
{
public:
    explicit PreviewDevice( QObject* parent = nullptr );

private:
    void setDMXOperation( int deviceId, int duration, int angle, int velocity, bool active ) override;
};