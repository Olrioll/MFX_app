#include "PreviewDevice.h"

PreviewDevice::PreviewDevice( QObject* parent /*= nullptr*/ )
             : SequenceDevice( parent )
{
    setId( PREVIEW_DEVICE_ID );
    setMinAngle( MIN_ANGLE );
    setMaxAngle( MAX_ANGLE );
    setheight( 10 );
}

void PreviewDevice::setDMXOperation( int deviceId, int duration, int angle, int velocity, bool active )
{
    emit m_manager->drawPreviewInGui( duration, angle, velocity, active );
}