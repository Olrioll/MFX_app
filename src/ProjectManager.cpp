#include "ProjectManager.h"

#include <QDebug>
#include <QFile>

ProjectManager::ProjectManager(QObject *parent) : QObject(parent)
{
//    loadProject("test.mfx");
}

ProjectManager::~ProjectManager()
{
//    saveProject();
}

void ProjectManager::loadProject(QString fileName)
{
    QFile file(fileName);
    if (file.open(QIODevice::ReadOnly | QIODevice::Text))
    {
        _project = QJsonDocument::fromJson(file.readAll()).object();
    }
}

void ProjectManager::saveProject()
{
    QFile file("test.mfx");
        if (file.open(QIODevice::WriteOnly | QIODevice::Truncate))
        {
            QJsonDocument doc;
            doc.setObject(_project);
            file.write(doc.toJson());
        }
}
