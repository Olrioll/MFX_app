#pragma once

#include "SequenceDevice.h"

class PreviewDevice : public SequenceDevice
{
public:
    explicit PreviewDevice( QObject* parent = nullptr );

private:
    void setDMXOperation( int deviceId, const Operation* op, bool sendToWorker ) override;
};