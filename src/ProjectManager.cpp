#include "ProjectManager.h"

#include <QDebug>
#include <QFile>
#include <QJsonArray>
#include <QFileDialog>
#include <QStandardPaths>

ProjectManager::ProjectManager(SettingsManager &settngs, QObject *parent) : QObject(parent), _settings(settngs)
{
    loadProject(_settings.workDirectory() + "/test.json");
}

ProjectManager::~ProjectManager()
{
    saveProject();
}

QVariant ProjectManager::property(QString name) const
{
    return _properties.value(name);
}

void ProjectManager::setProperty(QString name, QVariant value)
{
    _properties.insert(name, value);
}

double ProjectManager::sceneFrameWidth() const
{
    return property("sceneFrameWidth").toDouble();
}

int ProjectManager::currentGroupIndex() const
{
    return m_currentGroupIndex;
}

QString ProjectManager::currentGroup() const
{
    return _groups[currentGroupIndex()].name;
}

void ProjectManager::loadProject(QString fileName)
{
    QFile file(fileName);
    if (file.open(QIODevice::ReadOnly | QIODevice::Text))
    {
        _project = QJsonDocument::fromJson(file.readAll()).object();

        // Загружаем группы приборов

        auto groupsArray = _project["groups"].toArray();
        foreach(auto group, groupsArray)
        {
            _groups.push_back(Group(group.toObject()));
        }

        // Загружаем список патчей

        auto patchesArray = _project["patches"].toArray();
        foreach(auto patch, patchesArray)
        {
            _patches.push_back(Patch(patch.toObject()));
        }

        // Загружаем свойства

        _properties = _project.value("properties").toObject().toVariantMap();
    }
}

void ProjectManager::saveProject()
{
    _project = {};

    // Сохранияем группы приборов

    QJsonArray groupsArray;
    foreach(auto group, _groups)
    {
        groupsArray.append(group.toJsonObject());
    }

    _project.insert("groups", groupsArray);

    // Сохраняем список патчей

    QJsonArray patchesArray;
    foreach(auto patch, _patches)
    {
        patchesArray.append(patch.toJsonObject());
    }

    _project.insert("patches", patchesArray);

    // Сохраняем свойства

    QJsonObject properties;
    auto keys = _properties.keys();
    foreach(auto key, keys)
    {
        properties.insert(key, _properties.value(key).toJsonValue());
    }

    _project.insert("properties", properties);

    QFile file(_settings.workDirectory() + "/test.json");
        if (file.open(QIODevice::WriteOnly | QIODevice::Truncate))
        {
            QJsonDocument doc;
            doc.setObject(_project);
            file.write(doc.toJson());
        }
}

QString ProjectManager::selectBackgroundImageDialog()
{
    return QFileDialog::getOpenFileName(nullptr, tr("Open Image"), QStandardPaths::writableLocation(QStandardPaths::DocumentsLocation), tr("Image Files (*.png *.jpg *.bmp)"));
}

bool ProjectManager::addGroup(QString name)
{
    foreach(auto group, _groups)
    {
       if(group.name == name)
           return false;
    }

    _groups.push_back(Group(name));
    emit groupCountChanged();
    return true;
}

void ProjectManager::removeGroup(QString name)
{
    int index = -1;
    for(int i = 0; i < _groups.size(); i++)
    {
       if(_groups[i].name == name)
       {
           index = i;
           break;
       }
    }

    if(index != -1)
    {
        _groups.removeAt(index);
        emit groupCountChanged();
    }
}

bool ProjectManager::renameGroup(QString newName)
{
    foreach(auto group, _groups)
    {
       if(group.name == newName)
           return false;
    }

   _groups[currentGroupIndex()].name = newName;

    emit groupChanged(currentGroupIndex());
   return true;
}

void ProjectManager::addPatchToGroup(QString groupName, int patchId)
{
    for(auto & group : _groups)
    {
        if(group.name == groupName)
        {
            if(!group.patches.contains(patchId))
                group.patches.push_back(patchId);
            break;
        }
    }

    emit groupChanged(currentGroupIndex());
}

void ProjectManager::addPatchesToGroup(QString groupName, QList<int> patchIDs)
{
    foreach(auto patchId, patchIDs)
    {
        addPatchToGroup(groupName, patchId);
    }
}

void ProjectManager::removePatchesFromGroup(QString groupName, QList<int> patchIDs)
{
    QList<int> newList;
    int groupIndex = -1;

    for(int j = 0; j < _groups.size(); j++)
    {
        if(_groups[j].name == groupName)
        {
            for(int i = 0; i < _groups[j].patches.size(); i++)
            {
                if(!patchIDs.contains(_groups[j].patches.at(i)))
                {
                    newList.push_back(_groups[j].patches.at(i));
                }
            }
            groupIndex = j;
            break;
        }
    }


    _groups[groupIndex].patches = newList;
    emit groupChanged(currentGroupIndex());
}

int ProjectManager::lastPatchId() const
{
    int id = 0;
    foreach(auto patch, _patches)
    {
        if(patch.property("ID").toInt() > id)
            id = patch.property("ID").toInt();
    }

    return id;
}

void ProjectManager::addPatch(QString type, QVariantList properties)
{
    Patch patch;
    patch.type = type;

    foreach(auto prop, properties)
    {
        patch.properties.push_back({prop.toMap().first().toString(), prop.toMap().last()});
    }
    _patches.push_back(patch);

    for(int i = 0; i < 20; i++)
    {
        bool hasUnplacedPatch = false;
        for(auto & currPatch : _patches)
        {
            if(currPatch.property("posXRatio").toDouble() == (0.05 + 0.01 * i) &&
                    currPatch.property("posYRatio").toDouble() == (0.05 + 0.01 * i))
            {
                hasUnplacedPatch = true;
            }
        }

        if(!hasUnplacedPatch)
        {
             _patches.last().setProperty("posXRatio", (0.05 + 0.01 * i));
            _patches.last().setProperty("posYRatio", (0.05 + 0.01 * i));
            emit patchListChanged();
            return;
        }
    }

    _patches.last().setProperty("posXRatio", 0.05);
    _patches.last().setProperty("posXRatio", 0.05);
    emit patchListChanged();
}

void ProjectManager::editPatch(QVariantList properties)
{
    Patch newPatch;

    foreach(auto prop, properties)
    {
        newPatch.properties.push_back({prop.toMap().first().toString(), prop.toMap().last()});
    }

    int changedIndex = -1;
    for(int i = 0; i < _patches.size(); i++)
    {
        if(_patches.at(i).property("ID") == properties.at(0).toMap().last().toInt())
        {
            changedIndex = i;
            newPatch.type = _patches.at(i).type;
            break;
        }
    }

    if(changedIndex != -1)
    {
        _patches.replace(changedIndex, newPatch);
        emit patchListChanged();
    }
}

QVariant ProjectManager::patchProperty(int id, QString propertyName) const
{
    for(int i = 0; i < _patches.size(); i++)
    {
        if(_patches[i].property("ID") == id)
        {
            return _patches[i].property(propertyName);
        }
    }

    return 0;
}

QVariant ProjectManager::patchPropertyForIndex(int index, QString propertyName) const
{
    return _patches[index].property(propertyName);
}

void ProjectManager::setPatchProperty(int id, QString propertyName, QVariant value)
{
    for(int i = 0; i < _patches.size(); i++)
    {
        if(_patches[i].property("ID") == id)
        {
            _patches[i].setProperty(propertyName, value);
            if(propertyName == "checked")
            {
                emit patchCheckedChanged(id, value.toBool());
            }
        }
    }
}

void ProjectManager::setPatchPropertyForIndex(int index, QString propertyName, QVariant value)
{
    _patches[index].setProperty(propertyName, value);
    if(propertyName == "checked")
    {
        emit patchCheckedChanged(patchPropertyForIndex(index, "ID").toInt(), value.toBool());
    }
}

void ProjectManager::removePatches(QList<int> IDs)
{
    QList<Patch> newList;
    for(auto & patch : _patches)
    {
        if(!IDs.contains(patch.property("ID").toInt()))
        {
            newList.push_back(patch);
        }

        else
        {
            for(auto & group : _groups)
            {
                group.patches.removeOne(patch.property("ID").toInt());
            }
        }
    }

    _patches = newList;
    emit patchListChanged();
}

int ProjectManager::patchCount() const
{
    return _patches.size();
}

int ProjectManager::patchIndexForId(int id) const
{
    for(int i = 0; i < _patches.size(); i++)
    {
        if(_patches[i].property("ID") == id)
        {
            return i;
        }
    }

    return -1;
}

QList<int> ProjectManager::patchesIdList(QString groupName) const
{
    foreach(auto group, _groups)
    {
        if(group.name == groupName)
            return group.patches;
    }

    return QList<int> {};
}

QString ProjectManager::patchType(int index) const
{
    return _patches[index].type;
}

QStringList ProjectManager::patchPropertiesNames(int index) const
{
    QStringList list;
    foreach(auto prop, _patches[index].properties)
        list.push_back(prop.first);
    return list;
}

QList<QVariant> ProjectManager::patchPropertiesValues(int index) const
{
    QList<QVariant> list;
    foreach(auto prop, _patches[index].properties)
        list.push_back(prop.second);
    return list;
}

QStringList ProjectManager::groupNames() const
{
    QStringList names;
    foreach(auto group, _groups)
        names.push_back(group.name);
    return names;

}

bool ProjectManager::isGroupContainsPatch(QString groupName, int patchId) const
{
    for(auto & group : _groups)
    {
        if(group.name == groupName)
        {
            foreach(auto currentPatchId, group.patches)
            {
                if(patchId == currentPatchId)
                    return true;
            }
        }
    }

    return false;
}

bool ProjectManager::isPatchHasGroup(int patchId) const
{
    for(auto & group : _groups)
    {
        if(isGroupContainsPatch(group.name, patchId))
        {
            return true;
        }
    }

    return false;
}

bool ProjectManager::isGroupVisible(QString groupName) const
{
    for(auto & group : _groups)
    {
        if(group.name == groupName)
        {
            return group.visible;
        }
    }

    return false;
}

void ProjectManager::setGroupVisible(QString groupName, bool state)
{
    int counter = 0;
    for(auto & group : _groups)
    {
        if(group.name == groupName)
        {
            group.visible = state;
            emit groupChanged(counter);
            break;
        }
        counter++;
    }
}

void ProjectManager::setCurrentGroupIndex(int currentGroupIndex)
{
    if (m_currentGroupIndex == currentGroupIndex)
        return;

    m_currentGroupIndex = currentGroupIndex;
    emit currentGroupIndexChanged(m_currentGroupIndex);
}

void ProjectManager::setCurrentGroup(QString name)
{
    int index = 0;
    foreach(auto group, _groups)
    {
        if(group.name == name)
        {
            setCurrentGroupIndex(index);
            return;
        }

        index++;
    }

    emit currentGroupIndexChanged(m_currentGroupIndex);
}

void ProjectManager::setSceneFrameWidth(double sceneFrameWidth)
{
   setProperty("sceneFrameWidth", sceneFrameWidth);
    emit sceneFrameWidthChanged(sceneFrameWidth);
}
