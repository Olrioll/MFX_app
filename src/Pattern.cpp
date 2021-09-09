#include "Pattern.h"

Operation::Operation(QObject *parent): QObject(parent)
{
}

Operation::Operation(const Operation & op): _time(op._time), _angle(op._angle), _velocity(op._velocity), _fireOn(op._fireOn)
{
}

int Operation::angleDegrees()
{
    return 210. / 255 * _angle - 105;
}

Pattern::Pattern(QObject* parent)
    : QObject(parent)
{
    setUuid(QUuid::createUuid());
}
