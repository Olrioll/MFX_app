#include "PreviewDevice.h"

PreviewDevice::PreviewDevice( QObject* parent /*= nullptr*/ )
             : SequenceDevice( parent )
{
    setMinAngle( -115 );
    setMaxAngle( 115 );
    setheight( 10 );
}

void PreviewDevice::setDMXOperation( int deviceId, const Operation* op, bool sendToWorker )
{
    int angle = 0;
    if( op != nullptr )
        angle = op->angleDegrees();

    if( (angle < minAngle()) || (angle > maxAngle()) ) // filter operations by angle
        return;

    if( op != nullptr )
    {
        //qDebug() << "drawOperationInGui " << deviceId << " " << op->duration() << " " << op->angleDegrees() << " " << op->velocity() << " " << op->active();
        emit m_manager->drawPreviewInGui( op->duration(), op->angleDegrees(), op->velocity(), op->active() );
    }
    else
    {
        //qDebug() << "endOfPattern " << deviceId;
        emit m_manager->endOfPreview();
    }
}