#include "ShotDevice.h"

ShotDevice::ShotDevice( QObject* parent /*= nullptr*/ ) : Device( parent )
{
    setDeviceType( DEVICE_TYPE_SEQUENCES );
    setImageFile( "qrc:/device_sequences" );

    m_patternTimer.setInterval( PATTERN_INTERVAL_MS );
    connect( &m_patternTimer, &QTimer::timeout, this, &SequenceDevice::onPatternTimerChanged );
}