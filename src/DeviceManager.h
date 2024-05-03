#pragma once

#include <QtCore/QObject>
#include <QtCore/QUuid>

#include "Device.h"
#include "SequenceDevice.h"
#include "QQmlObjectListModel.h"
#include "ComPortModel.h"
#include "PatternManager.h"


class DeviceManager : public QObject
{
    Q_OBJECT
    QML_OBJMODEL_PROPERTY(Device, devices)
    QSM_WRITABLE_CSTREF_PROPERTY_WDEFAULT(QString, comPort, ComPort, "") //Выбранный компорт
public:
    ComPortModel m_comPortModel;
    explicit DeviceManager(PatternManager* patternManager, QObject *parent = nullptr);
    void runPatternOnDevice(int deviceId, int patternNum);
    // todo: block device in ui, rename, change coordinates (by device id)
    Q_INVOKABLE void setSequenceDeviceProperty(int deviceId, bool checked, qreal posXRatio, qreal posYRatio);
    Q_INVOKABLE void runPreviewPattern( const QString& patternName );
    Q_INVOKABLE void finishChangeAngle( int deviceId, int angle );

    PatternManager* GetPatternManager() { return m_patternManager; }
    Device* m_previewDevice;

    Device* deviceById(int id);

signals:
    void drawOperationInGui(qulonglong deviceId, int duration, int angle, int velocity, bool active);
    void endOfPattern(qulonglong deviceId);
    void drawPreviewInGui( int duration, int angle, int velocity, bool active );
    void endOfPreview();
    void editChanged();

public slots:
    //void onRunPattern(int deviceId, quint64 time, const QString& patternName);
    void onRunPatternSingly( int deviceId, quint64 time, const QString& patternName );
    void onEditPatch(QVariantList properties);
    void reloadPattern();

private:
    void addSequenceDevice(int deviceId, bool checked, qreal posXRatio, qreal posYRatio);

private:
    PatternManager* m_patternManager;
};
