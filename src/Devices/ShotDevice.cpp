#include "ShotDevice.h"
#include "DmxWorker.h"

ShotDevice::ShotDevice( QObject* parent /*= nullptr*/ ) : Device( parent )
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
    m_operations = p.operations()->toList();

    if( m_operations.count() == 0 )
        return;

    m_op = m_operations.first(); // first operation of pattern
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
    qulonglong duration = 0;

    for( const Operation* op : pattern.operations()->toList() )
    {
        if( !op )
            continue;

        duration += op->duration();
    }

    duration /= 10;
    duration *= 10;

    return duration;
}