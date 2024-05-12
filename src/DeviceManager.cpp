#include "DeviceManager.h"
#include "PreviewDevice.h"
#include "PatternManager.h"
#include "ProjectManager.h"

DeviceManager::DeviceManager(PatternManager* patternManager, ProjectManager* projectManager, QObject *parent)
    : m_patternManager(patternManager)
    , m_ProjectManager(projectManager)
    , QObject(parent)
{
    m_devices = new QQmlObjectListModel<Device>(this);
    // connect(this, &DeviceManager::comPortChanged, DMXWorker::instance(), &DMXWorker::onComPortChanged); // disable comport until we come with working DMX512 library

    m_previewDevice = new PreviewDevice( this );
    m_previewDevice->m_manager = this;
}

Device *DeviceManager::deviceById(int id) const
{
    if( id == PREVIEW_DEVICE_ID )
        return m_previewDevice;

    for(const auto device : m_devices->toList())
        if( device->id() == id )
            return device;

    return nullptr;
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

void DeviceManager::onEditPatch(const QVariantList& properties)
{
    int id = -1;
    int minAng = MIN_ANGLE;
    int maxAng = MAX_ANGLE;
    int height = -1;

//    bool isId = false;
    bool isMinAng = false;
    bool isMaxAng = false;
    bool isHeight = false;
    //qDebug()<< "EditPatch"<<properties;
    for(const auto prop : properties)
    {
        const auto propMap = prop.toMap();
        if( propMap.isEmpty() )
            continue;

        QString stringFirst = propMap.first().toString();
        QVariant last = propMap.last();

        if(stringFirst == "ID")
        {
            id = last.toInt();
        }
        else if(stringFirst == "min ang")
        {
            if( !last.isNull() )
            {
                minAng = last.toInt();
                isMinAng = true;
            }
        }
        else if(stringFirst == "max ang")
        {
            if( !last.isNull() )
            {
                maxAng = last.toInt();
                isMaxAng = true;
            }
        }
        else if( stringFirst == "height" )
        {
            if( !last.isNull() )
            {
                height = last.toInt();
                isHeight = true;
            }
        }
    }

    Device* device = deviceById(id);
    if( !device || device->deviceType() != DEVICE_TYPE_SEQUENCES )
        return;

    SequenceDevice *sequenceDevice = reinterpret_cast<SequenceDevice*>(device);
    
    if(isMinAng)
        sequenceDevice->setMinAngle(minAng);

    if(isMaxAng)
        sequenceDevice->setMaxAngle(maxAng);

    if(isHeight)
        sequenceDevice->setheight(height);

    emit editChanged();
}

void DeviceManager::reloadPattern()
{
    qDebug();
    m_patternManager->initPatterns();
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
    //qDebug() << deviceId << " " << patternName;

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
    //qDebug() << patternName;

    Pattern* p = m_patternManager->patternByName( patternName );
    if( !p )
        return;

    m_previewDevice->runPatternSingly( p, 0 );
}

void DeviceManager::finishChangeAngle( int deviceId, int angle )
{
    Device* device = deviceById( deviceId );
    if( !device )
        return;

    device->finishChangeAngle( angle );
}

qulonglong DeviceManager::maxActionsDuration( const QList<int>& ids ) const
{
    qulonglong duration = 0;

    for( auto id : ids )
    {
        QString act = m_ProjectManager->patchProperty( id, "act" ).toString();
        duration = std::max( duration, actionDuration( act, id ) );
    }

    return duration;
}

qulonglong DeviceManager::actionDuration( const QString& actName, int deviceId ) const
{
    Pattern* pattern = m_patternManager->patternByName( actName );
    Device* device = deviceById( deviceId );

    if( pattern && device )
        return device->getDurationByPattern( *pattern );

    return 0;
}