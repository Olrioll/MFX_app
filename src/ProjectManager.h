#ifndef PROJECTMANAGER_H
#define PROJECTMANAGER_H

#include <QObject>
#include <QSettings>

#include <QSuperMacros.h>
#include <QQmlConstRefPropertyHelpers.h>
//#include <quazipfile.h>

#include "SettingsManager.h"
#include "JsonSerializable.h"

class ProjectManager : public QObject, public JsonSerializable
{

    Q_OBJECT
public:

    ProjectManager(SettingsManager &settngs, QObject *parent = nullptr);
    virtual ~ProjectManager();

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
    void loadProject(const QString& fileName);
    void defaultProject();
    void newProject();
    void saveProject();

    QString selectBackgroundImageDialog();
    QString selectAudioTrackDialog();
    QString openProjectDialog();
    QString saveProjectDialog();

    void setBackgroundImage(const QString& fileName);
    void setAudioTrack(const QString& fileName);

    bool hasUnsavedChanges() const; //Отвечает за индикацию, был ли проект изменен (значит, нужно попросить сохранить данные при закрытии программы)
private:
    void cleanWorkDirectory();
private:
    bool _hasUnsavedChanges = false;
    SettingsManager& _settings;
signals:
    void audioTrackFileChanged();
    void backgroundImageChanged();
    void sceneFrameWidthChanged(double sceneFrameWidth);
///////////////////////////////////////////////////////////////////////////////
///                          Работа с проектом END                           //
///////////////////////////////////////////////////////////////////////////////





///////////////////////////////////////////////////////////////////////////////
///                      Работа с сохранением данных                         //
///////////////////////////////////////////////////////////////////////////////
public slots:
    void setProperty(const QString& name, QVariant value);
    QVariant property(const QString& name) const;
///////////////////////////////////////////////////////////////////////////////
///                      Работа с сохранением данных END                     //
///////////////////////////////////////////////////////////////////////////////






///////////////////////////////////////////////////////////////////////////////
///                      Работа с патчами                                    //
///////////////////////////////////////////////////////////////////////////////
public slots:
    int lastPatchId() const;
    void addPatch(QString type, QVariantList properties);
    void onEditPatch(QVariantList properties);
    QVariant patchProperty(int id, QString propertyName) const;
    QVariant patchPropertyForIndex(int index, QString propertyName) const;
    QString patchType(int index) const;
    QVariantMap patchProperties(int index) const;
    QStringList patchPropertiesNames(int index) const;
    QList<QVariant> patchPropertiesValues(int index) const;
    void setPatchProperty(int id, const QString& propertyName, QVariant value);
    QVariantList patchesIdList(const QString& groupName) const;
    int patchIndexForId(int id) const;
    int patchCount() const;
    QList<int> checkedPatchesList() const;
    void removePatchesByIDs(const QStringList &ids);
signals:
    void patchListChanged();
    void patchCheckedChanged(int id, bool checked);
    void editPatch(QVariantList properties);
///////////////////////////////////////////////////////////////////////////////
///                      Работа с патчами END                               //
///////////////////////////////////////////////////////////////////////////////




///////////////////////////////////////////////////////////////////////////////
///                      Работа с группами                                   //
///////////////////////////////////////////////////////////////////////////////
public slots:
    bool isPatchHasGroup(int patchId) const;
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
private:
    QString _currentGroup;
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
signals:
    void addCue(QVariantMap properties);
///////////////////////////////////////////////////////////////////////////////
///                      Работа с кью END                                    //
///////////////////////////////////////////////////////////////////////////////




///////////////////////////////////////////////////////////////////////////////
///                      Работа с экшенами                                   //
///////////////////////////////////////////////////////////////////////////////
public slots:
    QVariantList cueActions(QString cueName) const;
    void onSetActionProperty(QString cueName, QString actionName, int patchId, QString propertyName, QVariant value);
signals:
    void setActionProperty(const QString &cueName, const QString &pattern, int deviceId, quint64 position);
///////////////////////////////////////////////////////////////////////////////
///                      Работа с экшенами   END                             //
///////////////////////////////////////////////////////////////////////////////
};

#endif // PROJECTMANAGER_H
