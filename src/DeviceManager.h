#pragma once

#include <QtCore/QObject>
#include <QtCore/QUuid>

#include "Device.h"
#include "QQmlObjectListModel.h"

class DeviceManager : public QObject
{
    Q_OBJECT
    QML_OBJMODEL_PROPERTY(Device, devices)
public:
    explicit DeviceManager(QObject *parent = nullptr);
    void runPatternOnDevice(int deviceId, int patternNum);
    // todo: block device in ui, rename, change coordinates (by device id)
};
