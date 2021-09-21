#ifndef PROJECTMANAGER_H
#define PROJECTMANAGER_H

#include <QObject>
#include <QSettings>

#include <QSuperMacros.h>
#include <QQmlConstRefPropertyHelpers.h>

#include "SettingsManager.h"
#include "JsonSerializable.h"

class ProjectManager : public QObject, public JsonSerializable
{

    Q_OBJECT

    QSM_WRITABLE_CSTREF_PROPERTY_WDEFAULT(QString, currentProjectName, CurrentProjectName, "") //Название текущего проекта
    QSM_WRITABLE_CSTREF_PROPERTY_WDEFAULT(QString, currentProjectFile, CurrentProjectFile, "") //Абсолютный путь к текущему проекту
    QSM_WRITABLE_CSTREF_PROPERTY_WDEFAULT(QString, currentProjectAudioTrack, CurrentProjectAudioTrack, "") //Имя текущего выбранного музыкального файла
    QSM_WRITABLE_CSTREF_PROPERTY_WDEFAULT(QString, currentProjectAudioTrackPath, CurrentProjectAudioTrackPath, "") //Абсолютный путь к текущему выбранному музыкальному файлу
    QSM_WRITABLE_CSTREF_PROPERTY_WDEFAULT(qlonglong, currentProjectAudioTrackDuration, CurrentProjectAudioTrackDuration, 0) //Длительность текущего выбранного музыкального файла в миллисекундах

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
    QStringList groupNames() const;
    bool isGroupVisible(QString groupName) const;
    void setGroupVisible(QString groupName, bool state);
    bool addGroup(QString name);
    void removeGroup(QString name);
    bool renameGroup(QString newName);
    void addPatchesToGroup(QString groupName, QList<int> patchIDs);
    void removePatchesFromGroup(QString groupName, QList<int> patchIDs);
    bool isGroupContainsPatch(QString groupName, int patchId) const;
    bool isPatchHasGroup(int patchId) const;
    int patchCount() const;
    QList<int> checkedPatchesList() const;

    void setProperty(QString name, QVariant value);
    QVariant property(QString name) const;

    int lastPatchId() const;
    void addPatch(QString type, QVariantList properties);
    void onEditPatch(QVariantList properties);
    QVariant patchProperty(int id, QString propertyName) const;
    QVariant patchPropertyForIndex(int index, QString propertyName) const;
    QString patchType(int index) const;
    QVariantMap patchProperties(int index) const;
    QStringList patchPropertiesNames(int index) const;
    QList<QVariant> patchPropertiesValues(int index) const;
    void setPatchProperty(int id, QString propertyName, QVariant value);
    QVariantList patchesIdList(QString groupName) const;
    int patchIndexForId(int id) const;

    QString currentGroup() const;
    void setCurrentGroup(QString name);

    void onAddCue(QVariantMap properties);
    QVariantList getCues() const;
    void addActionToCue(QString cueName, QString actionName, int patchId, int position);
    void setCueProperty(QString cueName, QString propertyName, QVariant value);

    QVariantList cueActions(QString cueName) const;
    void onSetActionProperty(QString cueName, QString actionName, int patchId, QString propertyName, QVariant value);
    void deleteCues(QStringList deletedCueNames);

signals:

    void audioTrackFileChanged();

    void currentGroupChanged(QString name);
    void groupChanged(QString name);
    void groupCountChanged();
    void patchListChanged();
    void patchCheckedChanged(int id, bool checked);
    void backgroundImageChanged();

    void sceneFrameWidthChanged(double sceneFrameWidth);
    void addCue(QVariantMap properties);
    void setActionProperty(const QString &cueName, const QString &pattern, int deviceId, quint64 position);
    void editPatch(QVariantList properties);

private:

    void cleanWorkDirectory();

    SettingsManager& _settings;
    bool _hasUnsavedChanges = false;
    QString _currentGroup;
};

#endif // PROJECTMANAGER_H
