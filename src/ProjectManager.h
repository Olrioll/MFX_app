#ifndef PROJECTMANAGER_H
#define PROJECTMANAGER_H

#include <QObject>
#include <QSettings>

#include <QSuperMacros.h>
#include <QQmlConstRefPropertyHelpers.h>
//#include <quazipfile.h>

#include "SettingsManager.h"
#include "JsonSerializable.h"
#include "FireBaseClouds.h"

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
    void setPrefire(QMap<QString, int> &&pref);

public slots:

    void loadProject(QString fileName);
    void reloadCurrentProject();
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
    void removePatches(const QList<int> patchIds);
    void removeSelectedPatches();
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
    void uncheckPatch();
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
    void copyCues(QStringList copyCueNames);
    void changeAction(QString cueName, int deviceId, QString pattern);
    void saveJsonOut();
    void onMirror(const QString &cueName, QList<int> deviceId);
    void onInsideOutside(const QString &cueName, QList<int> deviceId, bool inside);
    void onRandom(const QString &cueName, QList<int> deviceId);
    QStringList maxActWidth(const QList<int> &ids);
    void setMsecPerPx(double ms){  msperpx = ms;}
    double getMsecPerPx(){return msperpx;}
    void updateCurrent();

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
    void deleteAllCue();
    void reloadCues();
    void setActionProperty(const QString &cueName, const QString &pattern, int deviceId, quint64 position);
    void editPatch(QVariantList properties);
    void pasteCues(QStringList pastedCues);
    void updateCues(QString cueName);
    void reloadPattern();

private:
    void updateCoeffByName(QString cueName);
    void cleanWorkDirectory();

    SettingsManager& _settings;
    bool _hasUnsavedChanges = false;
    QString _currentGroup;
    QStringList _pastedCues;
    QMap<QString,int> m_prefire;
//    FireBaseClouds clouds;
   double msperpx = 1;
};

#endif // PROJECTMANAGER_H
