#include "ActionsManager.h"
#include <QDebug>

ActionsManager::ActionsManager(SettingsManager &settngs, QObject *parent) : QObject(parent), _settings(settngs)
{

}

void ActionsManager::loadActions()
{
    QFile file(_settings.workDirectory() + "/actions.json");

    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
        return;

    _actions.clear();
    auto actionsArray = QJsonDocument::fromJson(file.readAll()).object()["actions"].toArray();
    foreach(auto action, actionsArray)
    {
        _actions.push_back(Action(action.toObject()));
    }

    emit actionsLoaded();
}

QVariantList ActionsManager::getActions() const
{
    QVariantList actionsList;
    for(auto & action : _actions)
    {
       actionsList.push_back(action.properties);
    }

    return actionsList;
}

QVariantMap ActionsManager::actionProperties(QString name) const
{
    for(auto & action : _actions)
    {
        if(action.property("name").toString() == name)
        {
            return action.properties;
        }
    }

    return QVariantMap();
}
