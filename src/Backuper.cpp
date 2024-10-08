#include <QtConcurrent/QtConcurrent>

#include "Backuper.h"

constexpr char APP_STATUS[] = "appStatus";
constexpr char BACKUP_FILE[] = "project.backup";

enum class AppStatus
{
    Undef = 0,
    Running = 1,
    Exit = 2
};

Backuper::Backuper( ProjectManager& projectManager, SettingsManager& settngs )
        : mProjectManager( projectManager )
        , mSettings( settngs )
{
    int interval = mSettings.value( AUTO_BACKUP_INTERVAL_SEC ).toInt();
    if( interval >= AUTO_BACKUP_DEF_INTERVAL_SEC )
    {
        connect( &mAutoBackupTimer, &QTimer::timeout, this, &Backuper::onAutoBackupTimerChanged );
        mAutoBackupTimer.start( interval * 1000 );

        qDebug() << "Start backuper with interval " << interval << " sec";
    }
    else
        qDebug() << "Backuper is off";
}

void Backuper::makeBackup()
{
    if( mProjectManager.hasUnsavedChanges() )
        mProjectManager.saveProjectToFile( QDir( mSettings.workDirectory() ).filePath( BACKUP_FILE ) );
}

bool Backuper::restoreBackup()
{
    qDebug();
    return mProjectManager.loadProjectFromFile( QDir( mSettings.workDirectory() ).filePath( BACKUP_FILE ) );
}

void Backuper::runProject()
{
    bool projectLoaded = false;

    AppStatus appStatus = static_cast<AppStatus>( mSettings.value( APP_STATUS ).toInt() );
    if( appStatus == AppStatus::Running )
    {
        qDebug() << "App crash detected. Try to load from backup";
        
        if( !restoreBackup() )
            mProjectManager.defaultProject();

        projectLoaded = true;
    }

    if( !projectLoaded )
        mProjectManager.defaultProject();

    mSettings.setValue( APP_STATUS, static_cast<int>(AppStatus::Running) );
}

void Backuper::exitProject()
{
    mAutoBackupTimer.stop();
    mSettings.setValue( APP_STATUS, static_cast<int>(AppStatus::Exit) );
}

void Backuper::onAutoBackupTimerChanged()
{
    if( mAutoBackupRun )
    {
        qDebug() << "makeBackup already running";
        return;
    }

    mAutoBackupRun = true;

    QFutureWatcher<void>* watcher = new QFutureWatcher<void>();

    connect( watcher, &QFutureWatcher<void>::finished, this, [=]
    {
        mAutoBackupRun = false;
        watcher->deleteLater();
    });

    QFuture<void> future = QtConcurrent::run( this, &Backuper::makeBackup );
    watcher->setFuture( future );
}