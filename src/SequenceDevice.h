#ifndef SEQUENCEDEVICE_H
#define SEQUENCEDEVICE_H

#include "Device.h"
#include <QObject>

class SequenceDevice : public Device
{
    Q_OBJECT
public:
    explicit SequenceDevice(QObject *parent = nullptr);
    void runPattern(int num);

private:
    QString comPort;
    int dmx;
    int rfChannel;
    int rfPosition;
    int maxAngle;
    int minAngle;
    int height;
};

#endif // SEQUENCEDEVICE_H
