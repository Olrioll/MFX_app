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

//    struct Action
//    {
//        QVariantMap properties;

//        Action() {}

//        Action(const QJsonObject& actionObject)
//        {
//            properties = actionObject["properties"].toObject().toVariantMap();
//        }

//        QJsonObject toJsonObject() const
//        {
//            QJsonObject actionObject;
//            actionObject.fromVariantMap(properties);

//            return actionObject;
//        }

//        QVariant property(QString name) const
//        {
//            return properties[name];
//        }

//        void setProperty(QString name, QVariant value)
//        {
//            properties[name] = value;
//        }
//    };

    ActionsManager(SettingsManager &settngs, QObject *parent = nullptr);

    void loadActions();

public slots:

    QVariantList getActions() const;
    QVariantMap actionProperties(QString name) const;

signals:

    void actionsLoaded();

private:

    SettingsManager& _settings;
    QList<QVariantMap> _actions;

};

#endif // ACTIONSMANAGER_H
