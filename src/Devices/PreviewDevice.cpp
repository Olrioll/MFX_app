#include "PreviewDevice.h"
#include "DeviceManager.h"

PreviewDevice::PreviewDevice( DeviceManager* mng, QObject* parent /*= nullptr*/ )
             : SequenceDevice( mng, parent )
{
    setId( PREVIEW_DEVICE_ID );
    setMinAngle( MIN_SEQUENCE_ANGLE );
    setMaxAngle( MAX_SEQUENCE_ANGLE );
    setHeight( 10 );
}

void PreviewDevice::setDMXOper( int deviceId, int duration, int angle, int velocity, int height, const QString& colorType, bool active )
{
    emit m_manager->drawPreviewInGui( duration, angle, velocity, active );
}