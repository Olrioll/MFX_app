#include <QDebug>

#include "SettingsManager.h"

SettingsManager::SettingsManager(const QString& appDir, QObject *parent) :
    QObject(parent),
    _settings(_workDirectory + "/settings.ini", QSettings::IniFormat),
    _appDirectory( appDir )
{
    qDebug() << _workDirectory << " " << _appDirectory;
    _settings.setValue( "workDirectory", _workDirectory );
    _settings.setValue( "appDirectory", _appDirectory );

    SetDefaultValues();
}

SettingsManager::~SettingsManager()
{
    _settings.sync();
}

void SettingsManager::setValue(QString name, QVariant value)
{
    qDebug() << name << value;

    _settings.setValue(name, value);
    _settings.sync();
}

QVariant SettingsManager::value(QString name)
{
    return _settings.value(name);
}

QString SettingsManager::workDirectory()
{
    return _workDirectory;
}

QString SettingsManager::appDirectory()
{
    return _appDirectory;
}

void SettingsManager::SetDefaultValues()
{
    auto val = value( AUTO_BACKUP_INTERVAL_SEC );

    if( !val.isValid() || val.toInt() < AUTO_BACKUP_DEF_INTERVAL_SEC )
        setValue( AUTO_BACKUP_INTERVAL_SEC, AUTO_BACKUP_DEF_INTERVAL_SEC );
}