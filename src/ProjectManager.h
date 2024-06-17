#ifndef PROJECTMANAGER_H
#define PROJECTMANAGER_H

#include <QObject>
#include <QSettings>
#include <QRecursiveMutex>

#include <QSuperMacros.h>
#include <QQmlConstRefPropertyHelpers.h>
//#include <quazipfile.h>

#include "SettingsManager.h"
#include "JsonSerializable.h"

class DeviceManager;

class ProjectManager : public QObject, public JsonSerializable
{

    Q_OBJECT
public:

    explicit ProjectManager(SettingsManager &settngs, QObject *parent = nullptr);
    virtual ~ProjectManager();

    void SetDeviceManager( DeviceManager* deviceManager );

///////////////////////////////////////////////////////////////////////////////
///                          Работа с проектом                               //
///////////////////////////////////////////////////////////////////////////////
private:
    QSM_WRITABLE_CSTREF_PROPERTY_WDEFAULT(QString, currentProjectName, CurrentProjectName, "") //Название текущего проекта
    QSM_WRITABLE_CSTREF_PROPERTY_WDEFAULT(QString, currentProjectFile, CurrentProjectFile, "") //Абсолютный путь к текущему проекту
    QSM_WRITABLE_CSTREF_PROPERTY_WDEFAULT(QString, currentProjectAudioTrack, CurrentProjectAudioTrack, "") //Имя текущего выбранного музыкального файла
    QSM_WRITABLE_CSTREF_PROPERTY_WDEFAULT(QString, currentProjectAudioTrackPath, CurrentProjectAudioTrackPath, "") //Абсолютный путь к текущему выбранному музыкальному файлу
    QSM_WRITABLE_CSTREF_PROPERTY_WDEFAULT(qlonglong, currentProjectAudioTrackDuration, CurrentProjectAudioTrackDuration, 0) //Длительность текущего выбранного музыкального файла в миллисекундах

public slots:
    bool loadProject(const QString& fileName);
    void defaultProject();
    void reloadCurrentProject();
    void newProject();
    void saveProject();

    void saveProjectToFile( const QString& saveFile );

    QString selectBackgroundImageDialog();
    QString selectAudioTrackDialog();
    QString openProjectDialog();
    QString saveProjectDialog();

    void setBackgroundImage(const QString& fileName);
    void setAudioTrack(const QString& fileName);
    void setPrefire( const QMap<QString, int>& pref );

    bool hasUnsavedChanges() const; //Отвечает за индикацию, был ли проект изменен (значит, нужно попросить сохранить данные при закрытии программы)
    void removePatches(const QList<int> patchIds);
    void removeSelectedPatches();
    bool isPatchHasGroup(int patchId) const;
    void onBackgroundImageChanged();

signals:
    void audioTrackFileChanged();
    void backgroundImageChanged();
///////////////////////////////////////////////////////////////////////////////
///                          Работа с проектом END                           //
///////////////////////////////////////////////////////////////////////////////





///////////////////////////////////////////////////////////////////////////////
///                      Работа с сохранением данных                         //
///////////////////////////////////////////////////////////////////////////////
public slots:
    void setProperty(const QString& name, QVariant value);
    QVariant property(const QString& name) const;
    void setSceneScaleFactor( double scale );
///////////////////////////////////////////////////////////////////////////////
///                      Работа с сохранением данных END                     //
///////////////////////////////////////////////////////////////////////////////






///////////////////////////////////////////////////////////////////////////////
///                      Работа с патчами                                    //
///////////////////////////////////////////////////////////////////////////////
public slots:
    int lastPatchId() const;
    void addPatch(const QString& type, const QVariantList& properties);
    void onEditPatch(const QVariantList& properties);
    QVariant patchProperty(int id, const QString& propertyName) const;
    QVariant patchPropertyForIndex(int index, const QString& propertyName) const;
    QString patchType(int index) const;
    QVariantMap patchProperties(int index) const;
    QStringList patchPropertiesNames(int index) const;
    QList<QVariant> patchPropertiesValues(int index) const;
    void setPatchProperty(int id, const QString& propertyName, QVariant value);
    QVariantList patchesIdList(const QString& groupName) const;
    void uncheckPatch();
    int patchIndexForId(int id) const;
    int patchCount() const;
    QList<int> checkedPatchesList() const;
    void removePatchesByIDs(const QStringList &ids);
signals:
    void patchListChanged();
    void patchCheckedChanged(int id, bool checked);
    void editPatch(QVariantList properties);
    void changeEmiterScale();
///////////////////////////////////////////////////////////////////////////////
///                      Работа с патчами END                               //
///////////////////////////////////////////////////////////////////////////////




///////////////////////////////////////////////////////////////////////////////
///                      Работа с группами                                   //
///////////////////////////////////////////////////////////////////////////////
public slots:
    QString currentGroup() const;
    void setCurrentGroup(QString name);
    bool isGroupVisible(QString groupName) const;
    void setGroupVisible(QString groupName, bool state);
    bool addGroup(QString name);
    void removeGroup(QString name);
    bool renameGroup(QString newName);
    void addPatchesToGroup(QString groupName, QList<int> patchIDs);
    void removePatchesFromGroup(QString groupName, QList<int> patchIDs);
    bool isGroupContainsPatch(QString groupName, int patchId) const;
    QStringList groupNames() const;

signals:
    void currentGroupChanged(QString name);
    void groupChanged(QString name);
    void groupCountChanged();
///////////////////////////////////////////////////////////////////////////////
///                      Работа с группами END                               //
///////////////////////////////////////////////////////////////////////////////




///////////////////////////////////////////////////////////////////////////////
///                      Работа с кью                                        //
///////////////////////////////////////////////////////////////////////////////
public slots:
    void onAddCue(QVariantMap properties);
    QVariantList getCues() const;
    void addActionToCue(QString cueName, QString actionName, int patchId, int position);
    void setCueProperty(QString cueName, QString propertyName, QVariant value);
    void deleteCues(QStringList deletedCueNames);
    void copyCues(QStringList copyCueNames);
    void changeAction(QString cueName, int deviceId, QString pattern);
    void saveJsonOut();
    void onMirror(const QString &cueName, QList<int> deviceId);
    void onInsideOutside(const QString &cueName, QList<int> deviceId, bool inside);
    void onRandom(const QString &cueName, QList<int> deviceId);
    void setMsecPerPx(double ms){  msperpx = ms;}
    double getMsecPerPx(){return msperpx;}
    void updateCurrent();

signals:
    void addCue(QVariantMap properties);
///////////////////////////////////////////////////////////////////////////////
///                      Работа с кью END                                    //
///////////////////////////////////////////////////////////////////////////////




///////////////////////////////////////////////////////////////////////////////
///                      Работа с экшенами                                   //
///////////////////////////////////////////////////////////////////////////////
public slots:
    QVariantList cueActions(const QString& cueName) const;
    qulonglong cueActionDuration( const QString& cueName, const QString& actName ) const;
    void onSetActionProperty(QString cueName, QString actionName, int patchId, QString propertyName, QVariant value);
signals:
    void deleteAllCue();
    void reloadCues();
    void setActionProperty(const QString &cueName, const QString &pattern, int deviceId, quint64 position);
    void pasteCues(QStringList pastedCues);
    void updateCues(QString cueName);
    void reloadPattern();
///////////////////////////////////////////////////////////////////////////////
///                      Работа с экшенами   END                             //
///////////////////////////////////////////////////////////////////////////////
private:
    void updateCoeffByName(QString cueName);
    void cleanWorkDirectory();
    void correctSceneFrame();

    SettingsManager& _settings;
    DeviceManager* m_DeviceManager;
    bool _hasUnsavedChanges = false;
    QString _currentGroup;
    QStringList _pastedCues;
    QMap<QString,int> m_prefire;
    //FireBaseClouds clouds;
    double msperpx = 1;
    mutable QRecursiveMutex m_ProjectLocker;
};

#endif // PROJECTMANAGER_H
