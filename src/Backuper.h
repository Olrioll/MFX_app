#pragma once

#include <QObject>
#include <QTimer>

#include "ProjectManager.h"

class Backuper : public QObject
{
    Q_OBJECT;

public:
    Backuper( ProjectManager& projectManager, SettingsManager& settngs );

public slots:
    void makeBackup();
    bool restoreBackup();
    void runProject();
    void exitProject();
    void onAutoBackupTimerChanged();

private:
    ProjectManager& mProjectManager;
    SettingsManager& mSettings;
    QTimer mAutoBackupTimer;
};