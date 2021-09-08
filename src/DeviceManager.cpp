#include "DeviceManager.h"

DeviceManager::DeviceManager(QObject *parent) : QObject(parent)
{
    m_devices = new QQmlObjectListModel<Device>(this);
    connect(this, &DeviceManager::comPortChanged, DMXWorker::instance(), &DMXWorker::onComPortChanged);
    setComPort(m_comPortModel.stringList().at(0));
}

Device *DeviceManager::getDevice(int id)
{
    Device* device = NULL;
    for(const auto & d : m_devices->toList()) {
        if(d->id() == id) {
            device = d;
            break;
        }
    }
    return device;
}

void DeviceManager::addSequenceDevice(int deviceId, bool checked, qreal posXRatio, qreal posYRatio)
{
    Device* newSequenceDevice = new SequenceDevice(this);
    newSequenceDevice->setId(deviceId);
    newSequenceDevice->setChecked(checked);
    newSequenceDevice->setPosXRatio(posXRatio);
    newSequenceDevice->setPosYRatio(posYRatio);
    m_devices->append(newSequenceDevice);
}

void DeviceManager::setSequenceDeviceProperty(int deviceId, bool checked, qreal posXRatio, qreal posYRatio)
{
    Device *device = getDevice(deviceId);
    if(device == NULL) {
        addSequenceDevice(deviceId, checked, posXRatio, posYRatio);
        return;
    }
    if(device->deviceType() != DEVICE_TYPE_SEQUENCES) {
        qDebug() << "incorrect device type!!!"; // todo: do something with it
        return;
    }
    device->setChecked(checked);
    device->setPosXRatio(posXRatio);
    device->setPosYRatio(posYRatio);
}

void DeviceManager::onRunPattern(int deviceId, QString patternName)
{
    Device *device = getDevice(deviceId);
    if(device == NULL) {
        return;
    }
    Pattern *p = m_patternManager->patternByName(patternName);
    device->runPattern(p);
    emit drawPatternInGui(deviceId, patternName);
}
