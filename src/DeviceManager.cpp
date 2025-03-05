#include <QtCore/QTime>

#include "DeviceManager.h"
#include "Devices/SequenceDevice.h"
#include "Devices/ShotDevice.h"
#include "Devices/PreviewDevice.h"
#include "PatternManager.h"
#include "ProjectManager.h"
#include "DmxWorker.h"
#include "Action.h"

DeviceManager::DeviceManager(PatternManager* patternManager, ProjectManager* projectManager, QObject *parent)
    : m_patternManager(patternManager)
    , m_ProjectManager(projectManager)
    , QObject(parent)
{
    m_devices = new QQmlObjectListModel<Device>(this);
    // connect(this, &DeviceManager::comPortChanged, DMXWorker::instance(), &DMXWorker::onComPortChanged); // disable comport until we come with working DMX512 library

    m_previewSeqDevice = new PreviewDevice( this, this );
    m_previewShotDevice = new ShotDevice( this, this );
}

void DeviceManager::qmlRegister()
{
    qRegisterMetaType<Device*>( "Device*" );
}

Device* DeviceManager::getDeviceById(int id) const
{
    for(const auto device : m_devices->toList())
        if( device->id() == id )
            return device;

    return nullptr;
}

Device* DeviceManager::getPreviewDevice( PatternType::Type type ) const
{
    if( type == PatternType::Sequences )
        return m_previewSeqDevice;

    if( type == PatternType::Shot )
        return m_previewShotDevice;

    return nullptr;
}

qulonglong DeviceManager::getDurationByPattern( PatternType::Type type, const QString& patternName ) const
{
    Device* device = getPreviewDevice( type );
    if( !device )
        return 0;

    const Pattern* p = m_patternManager->patternByName( patternName );
    if( !p )
        return 0;

    return device->getDurationByPattern( *p );
}

QString DeviceManager::getDurationStrByPattern( PatternType::Type type, const QString& patternName ) const
{
    return QTime::fromMSecsSinceStartOfDay( getDurationByPattern( type, patternName ) ).toString( "hh:mm:ss.zzz" );
}

void DeviceManager::addDevice( PatternType::Type type, int deviceId, bool checked, qreal posXRatio, qreal posYRatio )
{
    Device* newDevice = nullptr;

    if( type == PatternType::Sequences )
        newDevice = new SequenceDevice( this, this );
    else if( type == PatternType::Shot )
        newDevice = new ShotDevice( this, this );

    newDevice->setId( deviceId );
    newDevice->setChecked( checked );
    newDevice->setPosXRatio( posXRatio );
    newDevice->setPosYRatio( posYRatio );

    if( type == PatternType::Sequences )
        connect( DMXWorker::instance(), &DMXWorker::playbackTimeChanged, reinterpret_cast<SequenceDevice*>( newDevice ), &SequenceDevice::onPlaybackTimeChanged );

    m_devices->append( newDevice );
}

void DeviceManager::setDeviceProperty( PatternType::Type type, int deviceId, bool checked, qreal posXRatio, qreal posYRatio )
{
    Device* device = getDeviceById( deviceId );
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
    QString colorType;
    qulonglong prefireDuation = 0;

//    bool isId = false;
    bool isAngle = false;
    bool isMinAng = false;
    bool isMaxAng = false;
    bool isHeight = false;
    bool isColorType = false;
    bool isPrefireDuation = false;

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
        else if( stringFirst == "prefireTime" )
        {
            if( !last.isNull() )
            {
                prefireDuation = last.toULongLong();
                isPrefireDuation = true;
            }
        }
    }

    Device* device = getDeviceById( id );
    if( !device  )
        return;

    if( isPrefireDuation )
        device->setPrefire( prefireDuation );

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

    Device* device = getDeviceById( deviceId );
    if( !device )
        return;

    const Pattern* p = m_patternManager->patternByName( patternName );
    if( !p )
        return;

    device->runPatternSingly( *p, time );
}

void DeviceManager::onRunActionSingly( const QString& cueName, const Action& action, quint64 time )
{
    Device* device = getDeviceById( action.deviceId() );
    if( !device )
        return;

    device->runActionSingly( cueName, action, time );
}

void DeviceManager::runPreviewPattern( const QString& patternName )
{
    //qDebug() << patternName;

    const Pattern* p = m_patternManager->patternByName( patternName );
    if( !p )
        return;

    m_previewSeqDevice->runPatternSingly( *p, 0 );
}

void DeviceManager::finishChangeAngle( int deviceId, int angle )
{
    Device* device = getDeviceById( deviceId );
    if( !device )
        return;

    device->finishChangeAngle( angle );
}

qulonglong DeviceManager::maxActionsDuration( const QList<int>& pathIds ) const
{
    qulonglong duration = 0;

    for( int pathId : pathIds )
    {
        const QString act = m_ProjectManager->patchProperty( pathId, "act" ).toString();
        duration = std::max( duration, actionDuration( act, pathId ) );
    }

    return duration;
}

qulonglong DeviceManager::maxActionsPrefire( const QList<int>& pathIds ) const
{
    qulonglong prefire = 0;

    for( int pathId : pathIds )
    {
        const QString act = m_ProjectManager->patchProperty( pathId, "act" ).toString();
        prefire = std::max( prefire, actionPrefire( act, pathId ) );
    }

    return prefire;
}

qulonglong DeviceManager::actionDuration( const QString& actName, int deviceId ) const
{
    const Pattern* pattern = m_patternManager->patternByName( actName );
    const Device* device = getDeviceById( deviceId );

    if( pattern && device )
        return device->getDurationByPattern( *pattern );

    return 0;
}

qulonglong DeviceManager::actionPrefire( const QString& actName, int deviceId ) const
{
    const Device* device = getDeviceById( deviceId );

    if( device && device->getPrefire() )
        return device->getPrefire();

    const Pattern* pattern = m_patternManager->patternByName( actName );
    return pattern ? pattern->prefireDuration() : 0;
}