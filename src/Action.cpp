#include "Action.h"

Action::Action(QObject *parent) : QObject(parent)
{
    setId(QUuid::createUuid());
}
