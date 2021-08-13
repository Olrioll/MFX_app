#ifndef PROJECTMANAGER_H
#define PROJECTMANAGER_H

#include <QObject>
#include <QSettings>

#include "SettingsManager.h"
#include "JsonSerializable.h"

class ProjectManager : public QObject, public JsonSerializable
{

    Q_OBJECT

public:

    ProjectManager(SettingsManager &settngs, QObject *parent = nullptr);
    virtual ~ProjectManager();

public slots:

    void loadProject(QString fileName);
    void newProject();
    void saveProject();

    QString selectBackgroundImageDialog();
    QString selectAudioTrackDialog();
    QString openProjectDialog();
    QString saveProjectDialog();

    void setBackgroundImage(QString fileName);
    void setAudioTrack(QString fileName);

    bool hasUnsavedChanges() const;
    QString currentProjectName() const;
    QStringList groupNames() const;
    bool isGroupVisible(QString groupName) const;
    void setGroupVisible(QString groupName, bool state);
    bool addGroup(QString name);
    void removeGroup(QString name);
    bool renameGroup(QString newName);
    int patchCount() const;

    void setProperty(QString name, QVariant value);
    QVariant property(QString name) const;

    int lastPatchId() const;
    void addPatch(QString type, QVariantList properties);
    QVariant patchProperty(int id, QString propertyName) const;
    QVariant patchPropertyForIndex(int index, QString propertyName) const;
    QString patchType(int index) const;
    QStringList patchPropertiesNames(int index) const;
    QList<QVariant> patchPropertiesValues(int index) const;
    void setPatchProperty(int id, QString propertyName, QVariant value);
    QVariantList patchesIdList(QString groupName) const;
    int patchIndexForId(int id) const;

    QString currentGroup() const;
    void setCurrentGroup(QString name);

signals:

    void audioTrackFileChanged();

    void currentGroupChanged(QString name);
    void groupChanged(QString name);
    void groupCountChanged();
    void patchListChanged();
    void patchCheckedChanged(int id, bool checked);
    void backgroundImageChanged();

    void sceneFrameWidthChanged(double sceneFrameWidth);

private:

    void cleanWorkDirectory();

    SettingsManager& _settings;
    QString _currentProjectFile = "";
    QString _currentProjectName = "";
    bool _hasUnsavedChanges = false;
    QString _currentGroup;
};

#endif // PROJECTMANAGER_H
