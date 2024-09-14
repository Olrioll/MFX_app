#include "ShotDevice.h"

ShotDevice::ShotDevice( QObject* parent /*= nullptr*/ ) : Device( parent )
{
    setDeviceType( PatternType::Shot );
    setImageFile( "qrc:/device_shot" );
}

void ShotDevice::runPatternSingly( const Pattern& p, quint64 time )
{

}

qulonglong ShotDevice::calcDurationByPattern( const Pattern& pattern ) const
{
    qulonglong duration = 0;

    for( const Operation* op : pattern.operations()->toList() )
    {
        if( !op )
            continue;

        duration += op->duration();
    }

    duration /= 10;
    duration *= 10;

    return duration;
}