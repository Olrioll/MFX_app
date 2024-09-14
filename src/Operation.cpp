#include "Operation.h"

Operation::Operation(QObject* parent)
    : QObject(parent)
{
}

Operation::Operation(const Operation& operation)
    : m_duration(operation.m_duration)
    , m_angle(operation.m_angle)
    , m_velocity(operation.m_velocity)
    , m_active(operation.m_active)
{
}

int Operation::angleDegrees() const
{
    return static_cast<int>((MAX_SEQUENCE_ANGLE - MIN_SEQUENCE_ANGLE) / 255.0 * m_angle + MIN_SEQUENCE_ANGLE);
}

QVariantMap Operation::getProperties() const
{
    QVariantMap properties;
    properties["duration"] = duration();
    properties["angle"] = angle();
    properties["velocity"] = velocity();
    properties["active"] = active();
    properties["skipOutOfAngles"] = skipOutOfAngles();

    return properties;
}

void Operation::setProperties( const QVariantMap& properties )
{
    setDuration( properties.value( "duration" ).toULongLong() );
    setAngle( properties.value( "angle" ).toInt() );
    setVelocity( properties.value( "velocity" ).toInt() );
    setActive( properties.value( "active" ).toBool() );
    setSkipOutOfAngles( properties.value( "skipOutOfAngles" ).toBool() );
}