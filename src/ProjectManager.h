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

            groupObject.insert("properties", patchesArray);
            return groupObject;
        }
    };

    struct Patch
    {
        int id;
        QMap<QString, int> properties;

        Patch() {}

        Patch(const QJsonObject& patchObject)
        {
            id = patchObject["id"].toInt();
            foreach(auto property, patchObject["properties"].toArray())
            {
                auto propObject = property.toObject();
                auto key = propObject.keys().first();
                properties.insert(key, propObject.value(key).toInt());
            }

        }

        QJsonObject toJsonObject() const
        {
            QJsonObject patchObject;
            patchObject.insert("id", id);

            QJsonArray propertiesArray;
            foreach(auto prop, properties)
            {
                QJsonObject propObject;
                propObject.insert(properties.key(prop), prop);
                propertiesArray.append(propObject);
            }

            patchObject.insert("properties", propertiesArray);
            return patchObject;
        }
    };

    explicit ProjectManager(QObject *parent = nullptr);
    ~ProjectManager();

    Q_PROPERTY(int currentGroupIndex READ currentGroupIndex WRITE setCurrentGroupIndex NOTIFY currentGroupIndexChanged)


public slots:

    void loadProject(QString fileName);
    void saveProject();

    QStringList groupNames() const;

    bool addGroup(QString name);
    void removeGroup(QString name);
    bool renameGroup(QString newName);

    void addPatch(QVariantList properties);
    int patchCount() const;
    QStringList patchPropertiesNames(int index);
    QList<int> patchPropertiesValues(int index);

    int currentGroupIndex() const;
    QString currentGroup() const;
    void setCurrentGroupIndex(int currentGroupIndex);
    void setCurrentGroup(QString name);

signals:

    void currentGroupIndexChanged(int currentGroupIndex);
    void groupChanged(int index);

private:

    QJsonObject _project;
    QList<Group> _groups;
    QList<Patch> _patches;

    int m_currentGroupIndex;
};

#endif // PROJECTMANAGER_H
