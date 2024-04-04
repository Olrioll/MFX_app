#include "DeviceManager.h"
#include "PreviewDevice.h"

DeviceManager::DeviceManager(QObject *parent) : QObject(parent)
{
    m_devices = new QQmlObjectListModel<Device>(this);
    // connect(this, &DeviceManager::comPortChanged, DMXWorker::instance(), &DMXWorker::onComPortChanged); // disable comport until we come with working DMX512 library

    m_previewDevice = new PreviewDevice( this );
    m_previewDevice->m_manager = this;
}

Device *DeviceManager::deviceById(int id)
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
    newSequenceDevice->m_manager = this;
    connect(DMXWorker::instance(), &DMXWorker::playbackTimeChanged, reinterpret_cast<SequenceDevice*>(newSequenceDevice), &SequenceDevice::onPlaybackTimeChanged);
    m_devices->append(newSequenceDevice);
}

void DeviceManager::setSequenceDeviceProperty(int deviceId, bool checked, qreal posXRatio, qreal posYRatio)
{
    Device *device = deviceById(deviceId);
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

void DeviceManager::onEditPatch(QVariantList properties)
{
    int id = -1;
    int minAng = -120;
    int maxAng = -120;
    int height = -1;

//    bool isId = false;
    bool isMinAnd = true;
    bool isMaxAnd = true;
    bool isHeight = true;
    qDebug()<< "EditPatch"<<properties;
    foreach(auto prop, properties)
    {
        if(prop.toMap().isEmpty()){
          isMinAnd = isMaxAnd = isHeight = false;
          continue;
        }

        QString stringFirst = prop.toMap().first().toString();
        QVariant last = prop.toMap().last();

        if(stringFirst == "ID") {
            id = last.toInt();
        }
        if(stringFirst == "min ang") {
            minAng = last.toInt();
            if(last.isNull())
                isMinAnd = false;

        }
        if(stringFirst == "max ang") {
            maxAng = last.toInt();
            if(last.isNull())
                isMaxAnd = false;
        }
        if(stringFirst == "height") {
            height = last.toInt();
            if(last.isNull())
                isHeight = false;
        }
    }
    Device *device = deviceById(id);
    if(device == NULL) {
        return;
    }
    if(device->deviceType() != DEVICE_TYPE_SEQUENCES) {
        return;
    }
    SequenceDevice *sequenceDevice = reinterpret_cast<SequenceDevice*>(device);
    if(isMinAnd)
    sequenceDevice->setMinAngle(minAng);

    if(isMaxAnd)
    sequenceDevice->setMaxAngle(maxAng);

    if(isHeight)
    sequenceDevice->setheight(height);
    emit editChanged();
}

void DeviceManager::reloadPattern()
{
 m_patternManager->initPatterns();
qDebug()<<"reloadPattern";
}

/*
void DeviceManager::onRunPattern(int deviceId, quint64 time, const QString& patternName)
{
    qDebug() << deviceId << " " << patternName;

    Device *device = deviceById(deviceId);
    if(device == nullptr)
        return;

    Pattern *p = m_patternManager->patternByName(patternName);
    qDebug()<<"RUNACTION: "<<time;
    device->runPattern(p, time);
}*/

void DeviceManager::onRunPatternSingly( int deviceId, quint64 time, const QString& patternName )
{
    qDebug() << deviceId << " " << patternName;

    Device* device = deviceById( deviceId );
    if( !device )
        return;

    Pattern* p = m_patternManager->patternByName( patternName );
    if( !p )
        return;

    device->runPatternSingly( p, time );
}

void DeviceManager::runPreviewPattern( const QString& patternName )
{
    qDebug() << patternName;

    Pattern* p = m_patternManager->patternByName( patternName );
    if( !p )
        return;

    m_previewDevice->runPatternSingly( p, 0 );
}