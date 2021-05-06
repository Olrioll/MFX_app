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
        QString type;
        QList<QPair<QString, int>> properties;

        Patch() {}

        Patch(const QJsonObject& patchObject)
        {
            id = patchObject["id"].toInt();
            type = patchObject["type"].toString();
            foreach(auto property, patchObject["properties"].toArray())
            {
                auto propObject = property.toObject();
                auto key = propObject.keys().first();
                properties.push_back({key, propObject.value(key).toInt()});
            }

        }

        QJsonObject toJsonObject() const
        {
            QJsonObject patchObject;
            patchObject.insert("id", id);
            patchObject.insert("type", type);

            QJsonArray propertiesArray;
            foreach(auto prop, properties)
            {
                QJsonObject propObject;
                propObject.insert(prop.first, prop.second);
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

    void addPatch(QString type, QVariantList properties);
    int patchCount() const;

    QString patchType(int index) const;
    QStringList patchPropertiesNames(int index) const;
    QList<int> patchPropertiesValues(int index) const;

    int currentGroupIndex() const;
    QString currentGroup() const;
    void setCurrentGroupIndex(int currentGroupIndex);
    void setCurrentGroup(QString name);

signals:

    void currentGroupIndexChanged(int currentGroupIndex);
    void groupChanged(int index);
    void patchListChanged();

private:

    QJsonObject _project;
    QList<Group> _groups;
    QList<Patch> _patches;

    int m_currentGroupIndex;
};

#endif // PROJECTMANAGER_H
