#include "SequenceDevice.h"

SequenceDevice::SequenceDevice(QObject *parent): Device(parent)
{
    setDeviceType(DEVICE_TYPE_SEQUENCES);
    setImageFile("qrc:/device_sequences");
}

void SequenceDevice::runPattern(Pattern *p, quint64 time)
{
    if(p == NULL) {
        return;
    }
    if(p->type() != PatternType::Sequential) {
        return;
    }
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
    }

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
    setDMXOperation(id(), m_op);
}

void SequenceDevice::onPlaybackTimeChanged(quint64 time)
{
    if(time == m_patternStopTime) {
        setDMXOperation(id(), NULL);
        m_patternStopTime = 0;
        return;
    }
    if(m_op == NULL) {
        return;
    }

    if(time == m_opStartTime + m_op->duration() - 10) {
        m_opStartTime = time + 10;
        m_operations.removeFirst();
        m_op = m_operations[0];
        setDMXOperation(id(), m_op);
        if(m_operations.count() == 1) {
            m_operations.clear();
            m_op = NULL;
            m_opStartTime = 0;
            return;
        }
    }
}

void SequenceDevice::setDMXOperation(int deviceId, Operation *op)
{
    int angle = 0;
    if(op != NULL) {
        angle = op->angleDegrees();
    }
    if((angle < minAngle()) || (angle > maxAngle())) { // filter operations by angle
        return;
    }
    if(op != NULL) {
        emit m_manager->drawOperationInGui(deviceId, op->duration(), op->angleDegrees(), op->velocity(), op->active());
    } else {
        emit m_manager->endOfPattern(deviceId);
    }
    DMXWorker::instance()->setOperation(deviceId, op);
}
