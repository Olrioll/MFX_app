#include "SequenceDevice.h"

SequenceDevice::SequenceDevice(QObject *parent): Device(parent)
{
    setDeviceType(DEVICE_TYPE_SEQUENCES);
    setImageFile("qrc:/device_sequences");
}

void SequenceDevice::runPattern(QString patternName)
{
    DMXWorker::instance()->write(QByteArray::fromHex(QVariant("DEADBEAF").toByteArray())); // todo: send simple DMX512 commands
}
