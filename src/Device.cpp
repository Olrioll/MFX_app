#include "Device.h"

Device::Device(QObject *parent) : QObject(parent)
{
    setId(QUuid::createUuid());
}
