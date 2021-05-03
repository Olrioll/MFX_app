#include "ProjectManager.h"

#include <QFile>

ProjectManager::ProjectManager(QObject *parent) : QObject(parent)
{
    _project.insert("name", "Test project");
}

ProjectManager::~ProjectManager()
{
    saveProject();
}

void ProjectManager::loadProject(QString fileName)
{
//    QFile file(fileName);
//        if (file.open(QIODevice::ReadOnly | QIODevice::Text))
//        {
//            scriptEngine->globalObject().setProperty(objectName, scriptEngine->toScriptValue((QJsonDocument::fromJson(file.readAll())).toVariant()));
//        }
}

void ProjectManager::saveProject()
{
    QFile file("test.mfx");
        if (file.open(QIODevice::WriteOnly))
        {
            QJsonDocument doc;
            doc.setObject(_project);
            file.write(doc.toJson());
        }
}
