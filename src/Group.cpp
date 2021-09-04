#include "Group.h"

Group::Group(QObject* parent)
    : QObject(parent)
{
    setId(QUuid::createUuid());
}
