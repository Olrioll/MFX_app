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
    explicit DeviceManager(QObject *parent = nullptr);
    void runPatternOnDevice(int deviceId, int patternNum);
    // todo: block device in ui, rename, change coordinates (by device id)
    Q_INVOKABLE void setSequenceDeviceProperty(int deviceId, bool checked, qreal posXRatio, qreal posYRatio);

    PatternManager *m_patternManager;

    Device* deviceById(int id);

signals:
    void drawOperationInGui(qulonglong deviceId, int duration, int angle, int velocity, bool active);
    void endOfPattern(qulonglong deviceId);

public slots:
    void onRunPattern(int deviceId, quint64 time, QString patternName);
    void onEditPatch(QVariantList properties);

private:
    void addSequenceDevice(int deviceId, bool checked, qreal posXRatio, qreal posYRatio);
};
