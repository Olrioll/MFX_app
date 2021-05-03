#ifndef PROJECTMANAGER_H
#define PROJECTMANAGER_H

#include <QObject>
#include <QJsonDocument>
#include <QJsonObject>

class ProjectManager : public QObject
{
    Q_OBJECT

public:

    explicit ProjectManager(QObject *parent = nullptr);
    ~ProjectManager();

public slots:

    void loadProject(QString fileName);
    void saveProject();

signals:

private:

    QJsonObject _project;

};

#endif // PROJECTMANAGER_H
