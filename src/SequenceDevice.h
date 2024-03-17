#pragma once

#include <QtCore/QObject>
#include <QtCore/QUuid>

#include "QQmlObjectListModel.h"
#include <QQmlConstRefPropertyHelpers.h>
#include <QQmlVarPropertyHelpers.h>
#include <QSuperMacros.h>

#include "Device.h"
#include "DmxWorker.h"
#include "DeviceManager.h"

class SequenceDevice : public Device {
    Q_OBJECT
    QSM_WRITABLE_CSTREF_PROPERTY_WDEFAULT(QString, comPort, ComPort, "") //ComPort устройства
    QSM_WRITABLE_VAR_PROPERTY_WDEFAULT(int, dmx, Dmx, 0) //DMX
    QSM_WRITABLE_VAR_PROPERTY_WDEFAULT(int, rfChannel, RfChannel, 0) //DMX
    QSM_WRITABLE_VAR_PROPERTY_WDEFAULT(int, rfPosition, RfPosition, 0) //DMX
    QSM_WRITABLE_VAR_PROPERTY_WDEFAULT(int, maxAngle, MaxAngle, 0) //DMX
    QSM_WRITABLE_VAR_PROPERTY_WDEFAULT(int, minAngle, MinAngle, 0) //DMX
    QSM_WRITABLE_VAR_PROPERTY_WDEFAULT(int, height, height, 0) //DMX
public:
    explicit SequenceDevice(QObject* parent = nullptr);
    //void runPattern(const Pattern* p, quint64 time) override;
    void runPatternSingly( const Pattern* p, quint64 time ) override;

public slots:
    void onPlaybackTimeChanged(quint64 time);
    void onPatternTimerChanged();

private:
    void doPlaybackTimeChanged( quint64 time, bool sendToWorker );
    virtual void setDMXOperation( int deviceId, const Operation* op, bool sendToWorker );

private:
    QList<Operation*> m_operations;
    Operation* m_op = NULL;
    quint64 m_opStartTime;
    quint64 m_patternStopTime;
    quint64 m_patternTime = 0;
    QTimer m_patternTimer;
};
