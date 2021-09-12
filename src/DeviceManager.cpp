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
    connect(DMXWorker::instance(), &DMXWorker::playbackTimeChanged, reinterpret_cast<SequenceDevice*>(newSequenceDevice), &SequenceDevice::onPlaybackTimeChanged);
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

void DeviceManager::editPatch(QVariantList properties)
{
    int id = -1;
    int minAng = -120;
    int maxAng = -120;
    int height = -1;
    foreach(auto prop, properties)
    {
        QString stringFirst = prop.toMap().first().toString();
        QVariant last = prop.toMap().last();

        if(stringFirst == "ID") {
            id = last.toInt();
        }
        if(stringFirst == "min ang") {
            minAng = last.toInt();
        }
        if(stringFirst == "max ang") {
            maxAng = last.toInt();
        }
        if(stringFirst == "height") {
            height = last.toInt();
        }
    }
    Device *device = getDevice(id);
    if(device == NULL) {
        return;
    }
    if(device->deviceType() != DEVICE_TYPE_SEQUENCES) {
        return;
    }
    SequenceDevice *sequenceDevice = reinterpret_cast<SequenceDevice*>(device);
    sequenceDevice->setMinAngle(minAng);
    sequenceDevice->setMaxAngle(maxAng);
    sequenceDevice->setheight(height);
}

void DeviceManager::onRunPattern(int deviceId, quint64 time, QString patternName)
{
    Device *device = getDevice(deviceId);
    if(device == NULL) {
        return;
    }
    Pattern *p = m_patternManager->patternByName(patternName);
    device->runPattern(p, time);
    emit drawPatternInGui(deviceId, patternName);
}
