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
    return static_cast<int>((MAX_ANGLE - MIN_ANGLE) / 255.0 * m_angle + MIN_ANGLE);
}
