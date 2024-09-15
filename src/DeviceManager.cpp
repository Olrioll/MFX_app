#include "DeviceManager.h"
#include "Devices/SequenceDevice.h"
#include "Devices/ShotDevice.h"
#include "Devices/PreviewDevice.h"
#include "PatternManager.h"
#include "ProjectManager.h"
#include "DmxWorker.h"

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

void DeviceManager::addDevice( PatternType::Type type, int deviceId, bool checked, qreal posXRatio, qreal posYRatio )
{
    Device* newDevice = nullptr;

    if( type == PatternType::Sequences )
        newDevice = new SequenceDevice( this );
    else if( type == PatternType::Shot )
        newDevice = new ShotDevice( this );

    newDevice->setId( deviceId );
    newDevice->setChecked( checked );
    newDevice->setPosXRatio( posXRatio );
    newDevice->setPosYRatio( posYRatio );
    newDevice->m_manager = this;

    if( type == PatternType::Sequences )
        connect( DMXWorker::instance(), &DMXWorker::playbackTimeChanged, reinterpret_cast<SequenceDevice*>( newDevice ), &SequenceDevice::onPlaybackTimeChanged );

    m_devices->append( newDevice );
}

void DeviceManager::setDeviceProperty( PatternType::Type type, int deviceId, bool checked, qreal posXRatio, qreal posYRatio )
{
    Device* device = deviceById( deviceId );
    if( !device )
        return addDevice( type, deviceId, checked, posXRatio, posYRatio );

    device->setChecked( checked );
    device->setPosXRatio( posXRatio );
    device->setPosYRatio( posYRatio );
}

void DeviceManager::onEditPatch(const QVariantList& properties)
{
    int id = -1;
    int angle = 0;
    int minAng = MIN_SEQUENCE_ANGLE;
    int maxAng = MAX_SEQUENCE_ANGLE;
    int height = -1;
    QString colorType = "";

//    bool isId = false;
    bool isAngle = false;
    bool isMinAng = false;
    bool isMaxAng = false;
    bool isHeight = false;
    bool isColorType = false;

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
        else if( stringFirst == "angle" )
        {
            if( !last.isNull() )
            {
                angle = last.toInt();
                isAngle = true;
            }
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
        else if( stringFirst == "color type" )
        {
            if( !last.isNull() )
            {
                colorType = last.toString();
                isColorType = true;
            }
        }
    }

    Device* device = deviceById( id );
    if( !device  )
        return;

    if( device->deviceType() == PatternType::Sequences )
    {
        SequenceDevice* sequenceDevice = reinterpret_cast<SequenceDevice*>( device );

        if( isMinAng )
            sequenceDevice->setMinAngle( minAng );

        if( isMaxAng )
            sequenceDevice->setMaxAngle( maxAng );

        if( isHeight )
            sequenceDevice->setHeight( height );

        if( isColorType )
            sequenceDevice->setColorType( colorType );
    }
    else if( device->deviceType() == PatternType::Shot )
    {
        ShotDevice* shotDevice = reinterpret_cast<ShotDevice*>( device );

        if( isAngle )
            shotDevice->setAngle( angle );

        if( isHeight )
            shotDevice->setHeight( height );

        if( isColorType )
            shotDevice->setColorType( colorType );
    }

    device->clearCalcDurations();

    emit editChanged();
}

void DeviceManager::reloadPattern()
{
    m_patternManager->reloadPatterns();
}

void DeviceManager::onRunPatternSingly( int deviceId, quint64 time, const QString& patternName )
{
    //qDebug() << deviceId << " " << patternName;

    Device* device = deviceById( deviceId );
    if( !device )
        return;

    const Pattern* p = m_patternManager->patternByName( patternName );
    if( !p )
        return;

    device->runPatternSingly( *p, time );
}

void DeviceManager::runPreviewPattern( const QString& patternName )
{
    //qDebug() << patternName;

    const Pattern* p = m_patternManager->patternByName( patternName );
    if( !p )
        return;

    m_previewDevice->runPatternSingly( *p, 0 );
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
    const Pattern* pattern = m_patternManager->patternByName( actName );
    Device* device = deviceById( deviceId );

    if( pattern && device )
        return device->getDurationByPattern( *pattern );

    return 0;
}