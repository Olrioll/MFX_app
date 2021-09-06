#include "Device.h"

Device::Device(QObject *parent) : QObject(parent)
{
    setUuid(QUuid::createUuid());
}
