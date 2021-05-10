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
        QList<QPair<QString, int>> properties;

        Patch() {}

        Patch(const QJsonObject& patchObject)
        {
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

        int property(QString name) const
        {
            foreach(auto prop, properties)
            {
                if(prop.first == name)
                    return prop.second;
            }

            return -1;
        }
    };

    explicit ProjectManager(QObject *parent = nullptr);
    ~ProjectManager();

    Q_PROPERTY(int currentGroupIndex READ currentGroupIndex WRITE setCurrentGroupIndex NOTIFY currentGroupIndexChanged)

    Q_INVOKABLE QVariant property(QString name);
    Q_INVOKABLE void setProperty(QString name, QVariant value);

//    Q_PROPERTY(double sceneFrameX READ sceneFrameX WRITE setSceneFrameX NOTIFY sceneFrameXChanged)
//    Q_PROPERTY(double sceneFrameY READ sceneFrameY WRITE setSceneFrameY NOTIFY sceneFrameYChanged)
//    Q_PROPERTY(double sceneFrameWidth READ sceneFrameWidth WRITE setSceneFrameWidth NOTIFY sceneFrameWidthChanged)
//    Q_PROPERTY(double sceneFrameHeight READ sceneFrameHeight WRITE setSceneFrameHeight NOTIFY sceneFrameHeightChanged)
//    Q_PROPERTY(double sceneWidth READ sceneWidth WRITE setSceneWidth NOTIFY sceneWidthChanged)
//    Q_PROPERTY(double sceneHeight READ sceneHeight WRITE setSceneHeight NOTIFY sceneHeightChanged)

//    Q_INVOKABLE double sceneFrameX() const;
//    Q_INVOKABLE double sceneFrameY() const;
//    Q_INVOKABLE double sceneFrameWidth() const;
//    Q_INVOKABLE double sceneFrameHeight() const;
//    Q_INVOKABLE double sceneWidth() const;
//    Q_INVOKABLE double sceneHeight() const;

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
    void removePatches(QList<int> indexes);
    int patchCount() const;
    int patchIndexForId(int id) const;
    QList<int> patchesIdList(QString groupName) const;

    QString patchType(int index) const;
    QStringList patchPropertiesNames(int index) const;
    QList<int> patchPropertiesValues(int index) const;

    int currentGroupIndex() const;
    QString currentGroup() const;
    void setCurrentGroupIndex(int currentGroupIndex);
    void setCurrentGroup(QString name);

//    void setSceneFrameX(double sceneFrameX);
//    void setSceneFrameY(double sceneFrameY);
//    void setSceneFrameWidth(double sceneFrameWidth);
//    void setSceneFrameHeight(double sceneFrameHeight);
//    void setSceneWidth(double sceneWidth);
//    void setSceneHeight(double sceneHeight);

signals:

    void currentGroupIndexChanged(int currentGroupIndex);
    void groupChanged(int index);
    void groupCountChanged();
    void patchListChanged();

    void sceneFrameXChanged(double sceneFrameX);
    void sceneFrameYChanged(double sceneFrameY);

    void sceneFrameWidthChanged(double sceneFrameWidth);

    void sceneFrameHeightChanged(double sceneFrameHeight);

    void sceneWidthChanged(double sceneWidth);

    void sceneHeightChanged(double sceneHeight);

private:

    QJsonObject _project;
    QList<Group> _groups;
    QList<Patch> _patches;

    QVariantMap _properties;

    int m_currentGroupIndex;
//    double m_sceneFrameX = 0.1;
//    double m_sceneFrameY = 0.1;
//    double m_sceneFrameWidth;
//    double m_sceneFrameHeight;
//    double m_sceneWidth = 10.5;
//    double m_sceneHeight = 5.6;
};

#endif // PROJECTMANAGER_H
