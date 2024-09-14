#include "Device.h"
#include "../Pattern.h"

Device::Device(QObject *parent) : QObject(parent)
{
    setUuid(QUuid::createUuid());
}

qulonglong Device::getDurationByPattern( const Pattern& pattern )
{
    const auto it = m_DurationsByPattern.constFind( pattern.name() );
    if( it == m_DurationsByPattern.constEnd() )
    {
        qulonglong duration = calcDurationByPattern( pattern );
        m_DurationsByPattern[pattern.name()] = duration;

        return duration;
    }

    return it.value();
}

void Device::clearCalcDurations()
{
    m_DurationsByPattern.clear();
}