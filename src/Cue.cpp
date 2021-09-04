#include "Cue.h"

Cue::Cue(QObject *parent) : QObject(parent)
{
    setId(QUuid::createUuid());
}
