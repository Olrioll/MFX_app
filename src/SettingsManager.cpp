#include <QDebug>

#include "SettingsManager.h"

SettingsManager::SettingsManager(QObject *parent) :
    QObject(parent),
    _settings(_workDirectory + "/settings.ini", QSettings::IniFormat)
{
    qDebug() << _workDirectory;
    _settings.setValue("workDirectory", _workDirectory);
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
    qDebug() << name << " " << _settings.value( name );
    return _settings.value(name);
}

QString SettingsManager::workDirectory()
{
    qDebug() << _workDirectory;
    return _workDirectory;
}
