#ifndef SETTINGSMANAGER_H
#define SETTINGSMANAGER_H

#include <QObject>
#include <QSettings>
#include <QStandardPaths>
#include <QDir>

class SettingsManager : public QObject
{
    Q_OBJECT

public:

    explicit SettingsManager(const QString& appDir, QObject *parent = nullptr);
    ~SettingsManager();

    Q_INVOKABLE void setValue(QString name, QVariant value);
    Q_INVOKABLE QVariant value(QString name);
    Q_INVOKABLE QString workDirectory();
    Q_INVOKABLE QString appDirectory();

signals:

private:

        QString _workDirectory = QStandardPaths::writableLocation(QStandardPaths::ConfigLocation); // For release version
        QString _appDirectory;
//        QString _workDirectory = QDir(".").absolutePath(); //For test version
//        QString _workDirectory = QDir("../..").absolutePath(); //For development

        QSettings _settings;

};

#endif // SETTINGSMANAGER_H
