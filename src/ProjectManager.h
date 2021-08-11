#ifndef PROJECTMANAGER_H
#define PROJECTMANAGER_H

#include <QObject>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QSharedPointer>
#include <QSettings>

#include "SettingsManager.h"

class ProjectManager : public QObject
{
    Q_OBJECT

public:

    struct Group
    {
        QString name;
        bool visible = true;
        QList<int> patches;

        Group(QString name)
        {
            this->name = name;
        }

        Group(const QJsonObject& groupObject)
        {
            name = groupObject["name"].toString();
            foreach(auto patchID, groupObject["patches"].toArray())
            {
                patches.push_back(patchID.toInt());
            }
        }

        QJsonObject toJsonObject() const
        {
            QJsonObject groupObject;
            groupObject.insert("name", name);

            QJsonArray patchesArray;
            foreach(int patchID, patches)
            {
                patchesArray.append(patchID);
            }

            groupObject.insert("patches", patchesArray);
            return groupObject;
        }
    };

    struct Patch
    {
        QString type;
        QList<QPair<QString, QVariant>> properties;

        Patch() {}

        Patch(const QJsonObject& patchObject)
        {
            type = patchObject["type"].toString();
            foreach(auto property, patchObject["properties"].toArray())
            {
                auto propObject = property.toObject();
                auto key = propObject.keys().first();
                properties.push_back({key, propObject.value(key).toVariant()});
            }

        }

        QJsonObject toJsonObject() const
        {
            QJsonObject patchObject;
            patchObject.insert("type", type);

            QJsonArray propertiesArray;
            foreach(auto prop, properties)
            {
                QJsonObject propObject;
                propObject.insert(prop.first, prop.second.toJsonValue());
                propertiesArray.append(propObject);
            }

            patchObject.insert("properties", propertiesArray);
            return patchObject;
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

    struct Cue
    {
        QList<QPair<QString, QVariant>> properties;
        QList<QPair<QString, QVariant>> actions;

        Cue() {}

        Cue(const QJsonObject& cueObject)
        {
            foreach(auto property, cueObject["properties"].toArray())
            {
                auto propObject = property.toObject();
                auto key = propObject.keys().first();
                properties.push_back({key, propObject.value(key).toVariant()});
            }

            foreach(auto action, cueObject["actions"].toArray())
            {
                auto actObject = action.toObject();
                auto key = actObject.keys().first();
                actions.push_back({key, actObject.value(key).toVariant()});
            }
        }

        QJsonObject toJsonObject() const
        {
            QJsonObject cueObject;

            QJsonArray propertiesArray;
            foreach(auto prop, properties)
            {
                QJsonObject propObject;
                propObject.insert(prop.first, prop.second.toJsonValue());
                propertiesArray.append(propObject);
            }

            cueObject.insert("properties", propertiesArray);

            QJsonArray actionsArray;
            foreach(auto action, actions)
            {
                QJsonObject actObject;
                actObject.insert(action.first, action.second.toJsonValue());
                actionsArray.append(actObject);
            }

            cueObject.insert("actions", actionsArray);

            return cueObject;
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

        void addAction(QString actionName, int position)
        {
            QVariantMap newActionProperties;
            newActionProperties.insert("position", position);
            actions.push_back({actionName, newActionProperties});
        }
    };

    ProjectManager(SettingsManager &settngs, QObject *parent = nullptr);
    ~ProjectManager();

    Q_PROPERTY(int currentGroupIndex READ currentGroupIndex WRITE setCurrentGroupIndex NOTIFY currentGroupIndexChanged)

    Q_INVOKABLE QVariant property(QString name) const;
    Q_INVOKABLE void setProperty(QString name, QVariant value);

    Q_PROPERTY(double sceneFrameWidth READ sceneFrameWidth WRITE setSceneFrameWidth NOTIFY sceneFrameWidthChanged)

    Q_INVOKABLE double sceneFrameWidth() const;

public slots:

    void loadProject(QString fileName);
    void newProject();
    void saveProject();

    void setBackgroundImage(QString fileName);
    void setAudioTrack(QString fileName);

    QString selectBackgroundImageDialog();
    QString selectAudioTrackDialog();
    QString openProjectDialog();
    QString saveProjectDialog();

    bool hasUnsavedChanges() const;
    QString currentProjectFileName() const;
    QString currentProjectName() const;
    void setCurrentProjectName(QString name);
    QStringList groupNames() const;
    bool isGroupContainsPatch(QString groupName, int patchId) const;
    bool isPatchHasGroup(int patchId) const;
    bool isGroupVisible(QString groupName) const;
    void setGroupVisible(QString groupName, bool state);

    bool addGroup(QString name);
    void removeGroup(QString name);
    bool renameGroup(QString newName);
    void addPatchToGroup(QString groupName, int patchId);
    void addPatchesToGroup(QString groupName, QList<int> patchIDs);
    void removePatchesFromGroup(QString groupName, QList<int> patchIDs);

    int lastPatchId() const;
    void addPatch(QString type, QVariantList properties);
    void editPatch(QVariantList properties);
    QVariant patchProperty(int id, QString propertyName) const;
    QVariant patchPropertyForIndex(int index, QString propertyName) const;
    void setPatchProperty(int id, QString propertyName, QVariant value);
    void setPatchPropertyForIndex(int index, QString propertyName, QVariant value);
    void setPatchesInGroupChecked(QString groupName, bool state);
    void attemptToCheckPatches(QString groupName);
    void removePatches(QList<int> IDs);
    int patchCount() const;
    int patchIndexForId(int id) const;
    QList<int> patchesIdList(QString groupName) const;
    QList<int> checkedPatchesList() const;

    QString patchType(int index) const;
    QStringList patchPropertiesNames(int index) const;
    QList<QVariant> patchPropertiesValues(int index) const;

    void addCue(QVariantList properties);
    void deleteCues(QStringList names);
    int CueCount() const;
    void minimizeCueRowCount();
    int maxCueRow() const;
    QVariant getCueProperties(QString name) const;
    QVariantList getCues() const;
    void setCueProperty(QString cueName, QString propertyName, QVariant value);
    void addActionToCue(QString cueName, QString actionName, int position);
    QVariantList cueActions(QString cueName) const;

    int currentGroupIndex() const;
    QString currentGroup() const;
    void setCurrentGroupIndex(int currentGroupIndex);
    void setCurrentGroup(QString name);

    void setSceneFrameWidth(double sceneFrameWidth);

signals:

    void audioTrackFileChanged();

    void currentGroupIndexChanged(int currentGroupIndex);
    void groupChanged(int index);
    void groupCountChanged();
    void patchListChanged();
    void patchCheckedChanged(int id, bool checked);
    void backgroundImageChanged();

    void sceneFrameWidthChanged(double sceneFrameWidth);

private:

    void cleanWorkDirectoty();

    SettingsManager& _settings;
    QString _currentProjectFile = "";
    QString _currentProjectName = "";
    bool _hasUnsavedChanges = false;

    QJsonObject _project;
    QList<Group> _groups;
    QList<Patch> _patches;
    QList<Cue> _cues;

    QVariantMap _properties;

    int m_currentGroupIndex = 0;
};

#endif // PROJECTMANAGER_H
