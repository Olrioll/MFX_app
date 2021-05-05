#include "ProjectManager.h"

#include <QDebug>
#include <QFile>
#include <QJsonArray>

ProjectManager::ProjectManager(QObject *parent) : QObject(parent)
{
    loadProject("test.mfx");
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

    //----

    QFile file("test.mfx");
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
