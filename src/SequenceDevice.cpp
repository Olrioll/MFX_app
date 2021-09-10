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
    m_operations = p->operations()->toList();
    if(m_operations.count() == 0) {
        return;
    }
    m_op = m_operations[0]; // first operation of pattern
    DMXWorker::instance()->setOperation(id(), m_op);
}

void SequenceDevice::onPlaybackTimeChanged(quint64 time)
{
    if(m_op == NULL) {
        return;
    }
    if(time == m_opStartTime + m_op->duration()) {
        m_opStartTime = time;
        m_operations.removeFirst();
        m_op = m_operations[0];
        DMXWorker::instance()->setOperation(id(), m_op);
        if(m_operations.count() == 1) {
            m_operations.clear();
            m_op = NULL;
            m_opStartTime = 0;
            return;
        }
    }
}
