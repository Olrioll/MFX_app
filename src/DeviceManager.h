#ifndef DEVICEMANAGER_H
#define DEVICEMANAGER_H

#include <QDebug>
#include "Device.h"

class DeviceManager : public QObject
{
    Q_OBJECT
public:
    explicit DeviceManager(QObject *parent = nullptr);
    void runPatternOnDevice(int deviceId, int patternNum);
    // todo: block device in ui, rename, change coordinates (by device id)

signals:

private:
    QList<QSharedPointer<Device>> _devices;
};

#endif // DEVICEMANAGER_H

