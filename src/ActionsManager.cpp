#include "ActionsManager.h"
#include <QDebug>

ActionsManager::ActionsManager(SettingsManager &settngs, QObject *parent) : QObject(parent), _settings(settngs)
{

}

void ActionsManager::loadActions()
{
    QDir workDir(_settings.workDirectory());
    auto fileNamesList = workDir.entryList({"pattern*.txt"}, QDir::Files);

    for(auto & fileName : fileNamesList)
    {
        QFile file(_settings.workDirectory() + "/" + fileName);

        if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
            return;

        QStringList actionLines;
        QStringList controlLines;

        while(!file.atEnd())
        {
            auto currLine = file.readLine();

            if(currLine.startsWith("#"))
                controlLines.push_back(currLine);
            else
                actionLines.push_back(currLine);
        }

        QList<QStringList> rawActions;

        QStringList currRawAction;
        for(auto & line : actionLines)
        {
            if(line.startsWith("A"))
            {
                if(currRawAction.size())
                    rawActions.push_back(currRawAction);

                currRawAction.clear();
            }

            currRawAction.push_back(line);
        }

        if(currRawAction.size())
            rawActions.push_back(currRawAction);

        _actions.clear();

        for(auto & rawAction : rawActions)
        {
            QString name = rawAction.at(0);
            name.remove(',').chop(1);

            int prefire = rawAction.at(1).split(',').at(0).right(2).toInt() * 10;

            int duration = 0;

            for(int i = 2; i < rawAction.size(); i++)
            {
                duration += rawAction.at(i).split(',').at(0).toInt() * 10;
            }

            QVariantMap actObject;
            actObject.insert("name", name);
            actObject.insert("prefire", prefire);
            actObject.insert("duration", duration);
            _actions.push_back(actObject);
        }
    }

//    QFile file(_settings.workDirectory() + "/actions.json");

//    if (!file.open(QIODevice::ReadOnly | QIODevice::Text))
//        return;

//    _actions.clear();
//    auto actionsArray = QJsonDocument::fromJson(file.readAll()).object()["actions"].toArray();
//    foreach(auto action, actionsArray)
//    {
//        _actions.push_back(Action(action.toObject()));
//    }

    emit actionsLoaded();
}

QVariantList ActionsManager::getActions() const
{
    QVariantList actionsList;
    for(auto & action : _actions)
    {
       actionsList.push_back(action);
    }

    return actionsList;
}

QVariantMap ActionsManager::actionProperties(QString name) const
{
    for(auto & action : _actions)
    {
        if(action["name"].toString() == name)
        {
            return action;
        }
    }

    return QVariantMap();
}
