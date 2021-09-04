#include "Group.h"

Group::Group(QObject* parent)
    : QObject(parent)
{
    setUuid(QUuid::createUuid());
}
