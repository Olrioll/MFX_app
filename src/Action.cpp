#include "Action.h"

Action::Action(QObject *parent) : QObject(parent)
{
    setUuid(QUuid::createUuid());
}
