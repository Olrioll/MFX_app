#ifndef ACTIONSMANAGER_H
#define ACTIONSMANAGER_H

#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QSettings>

#include "SettingsManager.h"

class ActionsManager : public QObject
{
    Q_OBJECT

public:

    struct Action
    {
        QList<QPair<QString, QVariant>> properties;

        Action() {}

        Action(const QJsonObject& actionObject)
        {
            foreach(auto property, actionObject["properties"].toArray())
            {
                auto propObject = property.toObject();
                auto key = propObject.keys().first();
                properties.push_back({key, propObject.value(key).toVariant()});
            }

        }

        QJsonObject toJsonObject() const
        {
            QJsonObject actionObject;

            QJsonArray propertiesArray;
            foreach(auto prop, properties)
            {
                QJsonObject propObject;
                propObject.insert(prop.first, prop.second.toJsonValue());
                propertiesArray.append(propObject);
            }

            actionObject.insert("properties", propertiesArray);
            return actionObject;
        }

        QVariant property(QString name) const
        {
            foreach(auto prop, properties)
            {
                if(prop.first == name)
                    return prop.second;
            }

            return 0;
        }

        void setProperty(QString name, QVariant value)
        {
            for(auto & prop : properties)
            {
                if(prop.first == name)
                {
                    prop.second = value;
                    return;
                }
            }

            properties.push_back({name, value});
        }
    };

    ActionsManager(SettingsManager &settngs, QObject *parent = nullptr);

    void loadActions();

signals:

private:

    SettingsManager& _settings;
    QList<Action> _actions;

};

#endif // ACTIONSMANAGER_H
