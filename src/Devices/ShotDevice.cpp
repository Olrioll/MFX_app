#include "ShotDevice.h"
#include "DmxWorker.h"
#include "CueContent.h"

constexpr qulonglong FIRE_OFF_TIME_MS = 40;

ShotDevice::ShotDevice( DeviceManager* mng, QObject* parent /*= nullptr*/ ) : Device( mng, parent )
{
    setDeviceType( PatternType::Shot );
    setImageFile( "qrc:/device_shot" );

    m_patternTimer.setInterval( PATTERN_INTERVAL_MS );
    connect( &m_patternTimer, &QTimer::timeout, this, &ShotDevice::onPatternTimerChanged );
}

void ShotDevice::runPatternSingly( const Pattern& p, quint64 time )
{
    if( p.type() != PatternType::Shot )
        return;

    m_opStartTime = time;

    for( Operation* oper : m_operations )
        oper->deleteLater();

    m_operations.clear();

    {
        Operation* oper = new Operation( this );
        oper->setDuration( p.prefireDuration() );
        oper->setActive( false );

        m_operations.append( oper );
    }

    {
        Operation* oper = new Operation( this );
        oper->setDuration( p.getProperties()["shotTime"].toULongLong() );
        oper->setActive( true );

        m_operations.append( oper );
    }

    {
        Operation* oper = new Operation( this );
        oper->setDuration( FIRE_OFF_TIME_MS );
        oper->setActive( false );

        m_operations.append( oper );
    }

    m_op = m_operations.first();
    m_prefireDuration = m_op->duration();

    m_patternTime = time;
    m_patternTimer.start();

    setDMXOper( id(), 0, m_angle, 0, m_height, m_colorType, false ); // set angle
    setDMXOperation( id(), m_op, false );
}

void ShotDevice::onPlaybackTimeChanged( quint64 time )
{
    doPlaybackTimeChanged( time, true );
}

void ShotDevice::doPlaybackTimeChanged( quint64 time, bool sendToWorker )
{
    if( !m_op )
    {
        m_patternTimer.stop();

        setDMXOperation( id(), nullptr, sendToWorker );
        return;
    }

    if( time >= m_opStartTime + (m_prefireDuration ? m_prefireDuration : m_op->duration()) - 10 )
    {
        m_prefireDuration = 0;
        m_opStartTime = time + 10;
        m_operations.removeFirst();
        m_op = m_operations.count() ? m_operations.first() : nullptr;

        setDMXOperation( id(), m_op, sendToWorker );
    }
}


void ShotDevice::onPatternTimerChanged()
{
    m_patternTime += PATTERN_INTERVAL_MS;

    doPlaybackTimeChanged( m_patternTime, false );
}

void ShotDevice::setDMXOperation( int deviceId, const Operation* op, bool sendToWorker )
{
    int duration = 0;
    bool active = false;

    if( op != nullptr )
    {
        duration = op->duration();
        active = op->active();
    }

    if( op != nullptr )
    {
        setDMXOper( deviceId, duration, m_angle, 0, m_height, m_colorType, active );
    }

    if( sendToWorker && deviceId > 0 )
        DMXWorker::instance()->setOperation( deviceId, op );
}

qulonglong ShotDevice::calcDurationByPattern( const Pattern& pattern ) const
{
    qulonglong duration = pattern.getProperties()["shotTime"].toULongLong();
    duration /= 10;
    duration *= 10;

    return duration;
}

void ShotDevice::copyToCueContent( CueContent& cueContent ) const
{
    Device::copyToCueContent( cueContent );

    cueContent.setDmxSlot( dmx() );
    cueContent.setRfChannel( rfChannel() );
}