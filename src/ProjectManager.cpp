#include "ProjectManager.h"

#include <QDebug>
#include <QFile>
#include <QJsonArray>

ProjectManager::ProjectManager(QObject *parent) : QObject(parent)
{
    loadProject("test.json");
//    foreach(auto group, _groups)
//    {
//        qDebug() << group.name;
//        qDebug() << group.patches;
//    }
}

ProjectManager::~ProjectManager()
{
    saveProject();
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

    //----

    QFile file("test.json");
        if (file.open(QIODevice::WriteOnly | QIODevice::Truncate))
        {
            QJsonDocument doc;
            doc.setObject(_project);
            file.write(doc.toJson());
        }
}

bool ProjectManager::addGroup(QString name)
{
    foreach(auto group, _groups)
    {
       if(group.name == name)
           return false;
    }

    _groups.push_back(Group(name));
    emit groupChanged(_groups.size() - 1);
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
        emit groupChanged(index);
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
}

int ProjectManager::lastPatchId() const
{
    int id = 0;
    foreach(auto patch, _patches)
    {
        if(patch.property("ID") > id)
            id = patch.property("ID");
    }

    return id;
}

void ProjectManager::addPatch(QString type, QVariantList properties)
{
    Patch patch;
    patch.type = type;

    foreach(auto prop, properties)
    {
        patch.properties.push_back({prop.toMap().first().toString(), prop.toMap().last().toInt()});
    }

    _patches.push_back(patch);

    emit patchListChanged();
}

void ProjectManager::removePatches(QList<int> indexes)
{
    QList<Patch> newList;
    for(int i = 0; i < _patches.size(); i++)
    {
        if(!indexes.contains(i))
        {
            newList.push_back(_patches.at(i));
        }

        else
        {
            int removedId = _patches.at(i).property("ID");
            for(auto & group : _groups)
            {
                group.patches.removeOne(removedId);
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

QList<int> ProjectManager::patchPropertiesValues(int index) const
{
    QList<int> list;
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
}
