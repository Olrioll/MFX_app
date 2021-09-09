#include "SequenceDevice.h"

SequenceDevice::SequenceDevice(QObject *parent): Device(parent)
{
    setDeviceType(DEVICE_TYPE_SEQUENCES);
    setImageFile("qrc:/device_sequences");
}

void SequenceDevice::runPattern(Pattern *p)
{
    if(p->type() != PatternType::Sequential) {
        return;
    }
    qDebug() << "SequenceDevice::runPattern:" << p->name() << p->duration() << p->prefireDuration();
    foreach(Operation op, p->m_operationList) {
        qDebug() << tr("time: %1, angle: %2 (%3°), velocity: %4, fireOn: %5").arg(op.time()).arg(op.angle())
                    .arg(op.angleDegrees()).arg(op.velocity()).arg(op.fireOn());
    }
    DMXWorker::instance()->write(QByteArray::fromHex(QVariant("DEADBEAF").toByteArray())); // todo: send simple DMX512 commands
}
