#pragma once

#include <QtCore/QObject>
#include <QtCore/QUuid>

#include "Devices/Device.h"
#include "QQmlObjectListModel.h"
#include "ComPortModel.h"
#include "Patterns/Pattern.h"

class PatternManager;
class ProjectManager;

class DeviceManager : public QObject
{
    Q_OBJECT
    QML_OBJMODEL_PROPERTY(Device, devices)
    QSM_WRITABLE_CSTREF_PROPERTY_WDEFAULT(QString, comPort, ComPort, "") //Выбранный компорт
public:
    ComPortModel m_comPortModel;
    explicit DeviceManager(PatternManager* patternManager, ProjectManager* projectManager, QObject *parent = nullptr);

    // todo: block device in ui, rename, change coordinates (by device id)
    Q_INVOKABLE void setDeviceProperty( PatternType::Type type, int deviceId, bool checked, qreal posXRatio, qreal posYRatio );
    Q_INVOKABLE void runPreviewPattern( const QString& patternName );
    Q_INVOKABLE void finishChangeAngle( int deviceId, int angle );
    Q_INVOKABLE qulonglong maxActionsDuration( const QList<int>& ids ) const;
    Q_INVOKABLE qulonglong maxActionsPrefire( const QList<int>& ids ) const;
    Q_INVOKABLE qulonglong actionDuration( const QString& actName, int deviceId ) const;
    Q_INVOKABLE qulonglong actionPrefire( const QString& actName ) const;
    Q_INVOKABLE QString getDurationStrByPattern( PatternType::Type type, const QString& patternName ) const;
    Q_INVOKABLE Device* getDeviceById( int id ) const;

    PatternManager* GetPatternManager() { return m_patternManager; }
    Device* m_previewSeqDevice;
    Device* m_previewShotDevice;

    Device* getPreviewDevice( PatternType::Type type ) const;
    qulonglong getDurationByPattern( PatternType::Type type, const QString& patternName ) const;

signals:
    void drawOperationInGui(qulonglong deviceId, int duration, int angle, int velocity, int fireHeight, const QString& colorType, bool active);
    void endOfPattern(qulonglong deviceId);
    void drawPreviewInGui( int duration, int angle, int velocity, bool active );
    void endOfPreview();
    void editChanged();

public slots:
    //void onRunPattern(int deviceId, quint64 time, const QString& patternName);
    void onRunPatternSingly( int deviceId, quint64 time, const QString& patternName );
    void onEditPatch(const QVariantList& properties);
    void reloadPattern();

private:
    void addDevice( PatternType::Type type, int deviceId, bool checked, qreal posXRatio, qreal posYRatio );

private:
    PatternManager* m_patternManager;
    ProjectManager* m_ProjectManager;
};
