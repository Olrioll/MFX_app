#include "Cue.h"

Cue::Cue(QObject *parent) : QObject(parent)
{
    setUuid(QUuid::createUuid());
    m_actions = new QQmlObjectListModel<Action>(this);
}

QQmlObjectListModel<Action> *Cue::getActionsModel()
{
    return m_actions;
}
