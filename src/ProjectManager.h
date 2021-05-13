#ifndef PROJECTMANAGER_H
#define PROJECTMANAGER_H

#include <QObject>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>

class ProjectManager : public QObject
{
    Q_OBJECT

public:

    struct Group
    {
        QString name;
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
                properties.push_back({key, propObject.value(key).toDouble()});
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

    explicit ProjectManager(QObject *parent = nullptr);
    ~ProjectManager();

    Q_PROPERTY(int currentGroupIndex READ currentGroupIndex WRITE setCurrentGroupIndex NOTIFY currentGroupIndexChanged)

    Q_INVOKABLE QVariant property(QString name) const;
    Q_INVOKABLE void setProperty(QString name, QVariant value);

    Q_PROPERTY(double sceneFrameWidth READ sceneFrameWidth WRITE setSceneFrameWidth NOTIFY sceneFrameWidthChanged)

    Q_INVOKABLE double sceneFrameWidth() const;

public slots:

    void loadProject(QString fileName);
    void saveProject();

    QStringList groupNames() const;

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
    void removePatches(QList<int> indexes);
    int patchCount() const;
    int patchIndexForId(int id) const;
    QList<int> patchesIdList(QString groupName) const;

    QString patchType(int index) const;
    QStringList patchPropertiesNames(int index) const;
    QList<QVariant> patchPropertiesValues(int index) const;

    int currentGroupIndex() const;
    QString currentGroup() const;
    void setCurrentGroupIndex(int currentGroupIndex);
    void setCurrentGroup(QString name);

    void setSceneFrameWidth(double sceneFrameWidth);

signals:

    void currentGroupIndexChanged(int currentGroupIndex);
    void groupChanged(int index);
    void groupCountChanged();
    void patchListChanged();
    void patchCheckedChanged(int id, bool checked);

    void sceneFrameWidthChanged(double sceneFrameWidth);

private:

    QJsonObject _project;
    QList<Group> _groups;
    QList<Patch> _patches;

    QVariantMap _properties;

    int m_currentGroupIndex;
};

#endif // PROJECTMANAGER_H
