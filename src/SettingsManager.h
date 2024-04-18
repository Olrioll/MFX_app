#ifndef SETTINGSMANAGER_H
#define SETTINGSMANAGER_H

#include <QObject>
#include <QSettings>
#include <QStandardPaths>
#include <QDir>

constexpr char AUTO_BACKUP_INTERVAL_SEC[] = "autoBackupIntervalSec";
constexpr char PROJECT_FILE[] = "project.json";

constexpr int AUTO_BACKUP_DEF_INTERVAL_SEC = 15;

class SettingsManager : public QObject
{
    Q_OBJECT

public:

    explicit SettingsManager(const QString& appDir, QObject *parent = nullptr);
    ~SettingsManager();

    Q_INVOKABLE void setValue(const QString& name, const QVariant& value);
    Q_INVOKABLE QVariant value(const QString& name);
    Q_INVOKABLE QString workDirectory();
    Q_INVOKABLE QString appDirectory();

signals:

private:
    void SetDefaultValues();

private:

        QString _workDirectory = QStandardPaths::writableLocation(QStandardPaths::ConfigLocation); // For release version
        QString _appDirectory;
//        QString _workDirectory = QDir(".").absolutePath(); //For test version
//        QString _workDirectory = QDir("../..").absolutePath(); //For development

        QSettings _settings;

};

#endif // SETTINGSMANAGER_H
