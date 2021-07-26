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
}
