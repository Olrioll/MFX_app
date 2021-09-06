#include "SequenceDevice.h"

SequenceDevice::SequenceDevice(QObject *parent): Device(parent)
{
    setDeviceType(DEVICE_TYPE_SEQUENCES);
    setImageFile("qrc:/device_sequences");
}

void SequenceDevice::runPattern(QString patternName)
{
    qDebug() << "SequenceDevice::runPattern:" << id() << patternName; // todo: send commands to serialport
}

