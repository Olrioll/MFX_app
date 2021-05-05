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

void ProjectManager::addPatch(QVariantList properties)
{
    Patch patch;

    foreach(auto prop, properties)
    {
        patch.properties.insert(prop.toMap().first().toString(), prop.toMap().last().toInt());
    }

    _patches.push_back(patch);

    if(_patches.size() == 1)
        _patches.last().id = 0;
    else
        _patches.last().id = _patches.at(_patches.size() - 2).id + 1;
}

int ProjectManager::patchCount() const
{
    return _patches.size();
}

QString ProjectManager::patchType(int index) const
{
    return _patches[index].type;
}

QStringList ProjectManager::patchPropertiesNames(int index) const
{
    return _patches[index].properties.keys();
}

QList<int> ProjectManager::patchPropertiesValues(int index) const
{
    return _patches[index].properties.values();
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
