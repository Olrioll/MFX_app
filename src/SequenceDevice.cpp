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

    auto nOp = m_operations;
    auto first = true;
    auto firstDuration = -1;
    auto counter = 0;
    m_operations.erase(std::remove_if(m_operations.begin(),m_operations.end(),
                                      [&](const Operation* op){  auto r = ((op->angleDegrees() < minAngle()) || (op->angleDegrees() > maxAngle()));
        if(r && first  && counter == 0){
            first = false;
            firstDuration = op->duration();
        }

        ++counter;
        return  r ;}),m_operations.end());

    if(firstDuration != -1 && !m_operations.isEmpty() ){
        m_operations[0]->setDuration(firstDuration);
    }

    if(m_operations.count() == 0) {
        return;

    qDebug() << p->type() << " " << m_operations.count() << " " << m_opStartTime << " " << m_patternStopTime;


    if(nOp.size() != m_operations.size())
    {
        qDebug()<<"SequenceDevice.cpp operation size changed" << nOp.size() << m_operations.size()<< "\nAngle: "<<minAngle()<<maxAngle();
        for(auto& x: m_operations){
            qDebug()<<"  "<<x->angle() << x->duration();
        }
        for(auto& x: nOp){
            qDebug()<<" --- "<<x->angle() << x->duration();
        }
    }

    m_op = m_operations[0]; // first operation of pattern
    setDMXOperation(id(), m_op, true);
}*/

void SequenceDevice::runPatternSingly( const Pattern* p, quint64 time )
{
    if( !p || p->type() != PatternType::Sequential )
        return;

    m_opStartTime = time;
    //m_patternStopTime = time + p->duration() - 10; // time in DMXWorker is 10 ms before time in SequenceDevices
    m_operations = p->operations()->toList();

    /*auto nOp = m_operations;
    auto first = true;
    auto firstDuration = -1;
    auto counter = 0;

    m_operations.erase( std::remove_if( m_operations.begin(), m_operations.end(),
        [&]( const Operation* op )
    {
        auto r = ((op->angleDegrees() < minAngle()) || (op->angleDegrees() > maxAngle()));
        if( r && first && counter == 0 )
        {
            first = false;
            firstDuration = op->duration();
        }

        ++counter;
        return  r;
    } ), m_operations.end() );

    if( firstDuration != -1 && !m_operations.isEmpty() )
        m_operations[0]->setDuration( firstDuration );*/

    if( m_operations.count() == 0 )
        return;

    //qDebug() << p->type() << " " << m_operations.count() << " " << m_opStartTime << " " << m_patternStopTime;

    /*if( nOp.size() != m_operations.size() )
    {
        qDebug() << "Operation size changed" << nOp.size() << m_operations.size() << "\nAngle: " << minAngle() << maxAngle();

        for( auto& x : m_operations )
            qDebug() << "  " << x->angle() << x->duration();

        for( auto& x : nOp )
            qDebug() << " --- " << x->angle() << x->duration();
    }*/

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
    if( !m_op /*|| m_op->skipOutOfAngles() && time >= m_patternStopTime*/ )
    {
        m_patternTimer.stop();

        setDMXOperation( id(), nullptr, sendToWorker );

        //m_patternStopTime = 0;
        return;
    }

    if(time >= m_opStartTime + m_op->duration() - 10)
    {
        // для операций у которых не задано velocity время окончания определяется по duration
        // для операций у которых задано velocity, помимо duration ещё проверяем достигли ли мы заданного угла

        if( !m_op->velocity() || m_angleChangeFinished )
        {
            m_opStartTime = time + 10;
            m_operations.removeFirst();
            m_op = m_operations.count() ? m_operations[0] : nullptr;

            setDMXOperation( id(), m_op, sendToWorker );

            if( m_operations.count() <= 1 )
            {
                m_operations.clear();
                m_op = nullptr;
                m_opStartTime = 0;
            }
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
            return;

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
    emit m_manager->drawOperationInGui( deviceId, duration, angle, velocity, active );
}

void SequenceDevice::finishChangeAngle( int angle )
{
    qDebug() << "finishChangeAngle" << angle;
    m_angleChangeFinished = angle == m_angleDestination;
}