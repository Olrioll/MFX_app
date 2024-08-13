#include "SequenceDevice.h"

constexpr int PATTERN_INTERVAL_MS = 10;
constexpr int DEFAULT_START_ANGLE = 0;

SequenceDevice::SequenceDevice(QObject *parent): Device(parent)
{
    setDeviceType(DEVICE_TYPE_SEQUENCES);
    setImageFile("qrc:/device_sequences");

    m_patternTimer.setInterval( PATTERN_INTERVAL_MS );
    connect( &m_patternTimer, &QTimer::timeout, this, &SequenceDevice::onPatternTimerChanged );
}

void SequenceDevice::runPatternSingly( const Pattern* p, quint64 time )
{
    if( !p || p->type() != PatternType::Sequential )
        return;

    m_opStartTime = time;
    m_operations = p->operations()->toList();

    if( m_operations.count() == 0 )
        return;

    m_op = m_operations.first(); // first operation of pattern
    m_prefireDuration = m_op->duration();

    m_patternTime = time;
    m_patternTimer.start();

    setDMXOperation( id(), m_op, false );
}

void SequenceDevice::onPlaybackTimeChanged( quint64 time )
{
    doPlaybackTimeChanged( time, true );
}

void SequenceDevice::doPlaybackTimeChanged( quint64 time, bool sendToWorker )
{
    if( !m_op )
    {
        m_patternTimer.stop();

        setDMXOperation( id(), nullptr, sendToWorker );
        return;
    }

    if(time >= m_opStartTime + (m_prefireDuration ? m_prefireDuration : m_op->duration()) - 10)
    {
        // для операций у которых не задано velocity время окончания определяется по duration
        // для операций у которых задано velocity, помимо duration ещё проверяем достигли ли мы заданного угла

        if( !m_op->velocity() || m_angleChangeFinished )
        {
            m_prefireDuration = 0;
            m_opStartTime = time + 10;
            m_operations.removeFirst();
            m_op = m_operations.count() ? m_operations.first() : nullptr;

            setDMXOperation( id(), m_op, sendToWorker );
        }
    }
}


void SequenceDevice::onPatternTimerChanged()
{
    m_patternTime += PATTERN_INTERVAL_MS;

    doPlaybackTimeChanged( m_patternTime, false );
}

void SequenceDevice::setDMXOperation(int deviceId, const Operation *op, bool sendToWorker)
{
    int duration = 0;
    int angle = 0;
    int velocity = 0;
    bool active = false;
    bool skipOutOfAngles = true;

    if( op != nullptr )
    {
        duration = op->duration();
        angle = op->angleDegrees();
        velocity = op->velocity();
        active = op->active();
        skipOutOfAngles = op->skipOutOfAngles();
    }

    if( angle < minAngle() || angle > maxAngle() )
    {
        if( skipOutOfAngles )
        {
            m_operations.removeFirst();
            m_op = m_operations.count() ? m_operations.first() : nullptr;

            return setDMXOperation( deviceId, m_op, sendToWorker );
        }

        if( angle < minAngle() )
            angle = minAngle();
        else if( angle > maxAngle() )
            angle = maxAngle();
    }

    if(op != nullptr)
    {
        m_angleChangeFinished = false;
        m_angleDestination = angle;

        setDMXOperation( deviceId, duration, angle, velocity, active );
    }

    if( sendToWorker && deviceId > 0 )
        DMXWorker::instance()->setOperation(deviceId, op);
}

void SequenceDevice::setDMXOperation( int deviceId, int duration, int angle, int velocity, bool active )
{
    emit m_manager->drawOperationInGui( deviceId, duration, angle, velocity, m_height, m_colorType, active );
}

void SequenceDevice::finishChangeAngle( int angle )
{
    //qDebug() << "finishChangeAngle" << angle;
    m_angleChangeFinished = angle == m_angleDestination;
}

qulonglong SequenceDevice::calcDurationByPattern( const Pattern& pattern ) const
{
    int posAngle = DEFAULT_START_ANGLE;
    qulonglong duration = 0;

    for( const Operation* op : pattern.operations()->toList() )
    {
        if( !op )
            continue;

        int angle = op->angleDegrees();
        bool skipAngle = false;

        if( angle < minAngle() || angle > maxAngle() )
        {
            if( op->skipOutOfAngles() )
                skipAngle = true;
            else
            {
                if( angle < minAngle() )
                    angle = minAngle();
                else if( angle > maxAngle() )
                    angle = maxAngle();
            }
        }

        if( !skipAngle )
        {
            if( op->velocity() )
            {
                constexpr int min_velocity = 10;
                const int velocity = op->velocity() < min_velocity ? min_velocity : op->velocity();
                const double koef = 2.54 * velocity + 8.55;
                duration += abs( angle - posAngle ) / koef * 1000;
            }
            else
                duration += op->duration();

            posAngle = angle;
        }
    }

    duration /= 10;
    duration *= 10;

    return duration;
}