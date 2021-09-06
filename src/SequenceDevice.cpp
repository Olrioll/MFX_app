#include "SequenceDevice.h"

SequenceDevice::SequenceDevice(QObject *parent): Device(parent)
{
    setDeviceType(DEVICE_TYPE_SEQUENCES);
    setImageFile("qrc:/device_sequences");
}

void SequenceDevice::runPattern(QString patternName)
{
    qDebug() << "SequenceDevice::runPattern:" << id() << patternName << portName(); // todo: send commands to serialport
}

QString SequenceDevice::portName()
{
    return comPort();
}

void SequenceDevice::setPortName(QString portName)
{
    setComPort(portName);
}
