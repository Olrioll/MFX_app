#include "Device.h"
#include "DeviceManager.h"
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

void Device::setDMXOper( int deviceId, int duration, int angle, int velocity, int height, const QString& colorType, bool active )
{
    emit m_manager->drawOperationInGui( deviceId, duration, angle, velocity, height, colorType, active );
}