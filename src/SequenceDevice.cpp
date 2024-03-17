#include "SequenceDevice.h"

constexpr int PATTERN_INTERVAL_MS = 10;

SequenceDevice::SequenceDevice(QObject *parent): Device(parent)
{
    setDeviceType(DEVICE_TYPE_SEQUENCES);
    setImageFile("qrc:/device_sequences");

    m_patternTimer.setInterval( PATTERN_INTERVAL_MS );
    connect( &m_patternTimer, &QTimer::timeout, this, &SequenceDevice::onPatternTimerChanged );
}

/*
void SequenceDevice::runPattern(const Pattern *p, quint64 time)
{
    if(p == nullptr)
        return;

    if(p->type() != PatternType::Sequential)
        return;

    m_opStartTime = time;
    m_patternStopTime = time + p->duration() - 10; // time in DMXWorker is 10 ms before time in SequenceDevices
    m_operations = p->operations()->toList();
    if(m_operations.count() == 0)
        return;

    qDebug() << p->type() << " " << m_operations.count() << " " << m_opStartTime << " " << m_patternStopTime;

    m_op = m_operations[0]; // first operation of pattern
    setDMXOperation(id(), m_op, true);
}*/

void SequenceDevice::runPatternSingly( const Pattern* p, quint64 time )
{
    if( !p || p->type() != PatternType::Sequential )
        return;

    m_opStartTime = time;
    m_patternStopTime = time + p->duration() - 10; // time in DMXWorker is 10 ms before time in SequenceDevices
    m_operations = p->operations()->toList();

    if( m_operations.count() == 0 )
        return;

    //qDebug() << p->type() << " " << m_operations.count() << " " << m_opStartTime << " " << m_patternStopTime;

    m_op = m_operations[0]; // first operation of pattern

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
    if(time == m_patternStopTime)
    {
        m_patternTimer.stop();

        setDMXOperation(id(), nullptr, sendToWorker);

        m_patternStopTime = 0;
        return;
    }

    if(m_op == nullptr)
        return;

    if(time == m_opStartTime + m_op->duration() - 10)
    {
        m_opStartTime = time + 10;
        m_operations.removeFirst();
        m_op = m_operations.count() ? m_operations[0] : nullptr;

        setDMXOperation(id(), m_op, sendToWorker);

        if(m_operations.count() <= 1)
        {
            m_operations.clear();
            m_op = nullptr;
            m_opStartTime = 0;
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
    int angle = 0;
    if(op != nullptr)
        angle = op->angleDegrees();

    if((angle < minAngle()) || (angle > maxAngle())) // filter operations by angle
        return;

    if(op != nullptr)
    {
        //qDebug() << "drawOperationInGui " << deviceId << " " << op->duration() << " " << op->angleDegrees() << " " << op->velocity() << " " << op->active();
        emit m_manager->drawOperationInGui( deviceId, op->duration(), op->angleDegrees(), op->velocity(), op->active() );
    }
    else
    {
        emit m_manager->endOfPattern(deviceId);
    }

    if( sendToWorker )
        DMXWorker::instance()->setOperation(deviceId, op);
}
