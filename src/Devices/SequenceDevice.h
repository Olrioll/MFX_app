#pragma once

#include <QtCore/QObject>
#include <QtCore/QUuid>
#include <QTimer>

#include "QQmlObjectListModel.h"
#include "QQmlConstRefPropertyHelpers.h"
#include "QQmlVarPropertyHelpers.h"
#include "QSuperMacros.h"

#include "Device.h"

class SequenceDevice : public Device
{
    Q_OBJECT
    QSM_WRITABLE_CSTREF_PROPERTY_WDEFAULT(QString, comPort, ComPort, "") //ComPort устройства
    QSM_WRITABLE_CSTREF_PROPERTY_WDEFAULT(QString, colorType, ColorType, "")
    QSM_WRITABLE_VAR_PROPERTY_WDEFAULT(int, dmx, Dmx, 0) //DMX
    QSM_WRITABLE_VAR_PROPERTY_WDEFAULT(int, rfChannel, RfChannel, 0) //DMX
    QSM_WRITABLE_VAR_PROPERTY_WDEFAULT(int, rfPosition, RfPosition, 0) //DMX
    QSM_WRITABLE_VAR_PROPERTY_WDEFAULT(int, maxAngle, MaxAngle, 0) //DMX
    QSM_WRITABLE_VAR_PROPERTY_WDEFAULT(int, minAngle, MinAngle, 0) //DMX
    QSM_WRITABLE_VAR_PROPERTY_WDEFAULT(int, height, Height, 0) //DMX

public:
    explicit SequenceDevice( DeviceManager* mng, QObject* parent = nullptr );

    void copyToCueContent( CueContent& cueContent ) const override;

public slots:
    void onPlaybackTimeChanged(quint64 time);
    void onPatternTimerChanged();

private:
    void doPlaybackTimeChanged( quint64 time, bool sendToWorker );

    void runPatternSingly( const Pattern& p, quint64 time ) override;
    void finishChangeAngle( int angle ) override;

    qulonglong calcDurationByPattern( const Pattern& pattern ) const override;

    void setDMXOperation( int deviceId, const Operation* op, bool sendToWorker ) override;

private:
    QList<Operation*> m_operations;
    Operation* m_op = nullptr;
    quint64 m_opStartTime = 0;
    quint64 m_patternTime = 0;
    QTimer m_patternTimer;
    bool m_angleChangeFinished = false;
    int m_angleDestination = 0;
    qulonglong m_prefireDuration = 0;
};
