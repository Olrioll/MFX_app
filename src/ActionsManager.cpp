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
        QVariantMap actionProperties;
        for(auto & prop : action.properties)
        {
            actionProperties.insert(prop.first, prop.second);
        }

       actionsList.push_back(actionProperties);
    }

    return actionsList;
}
