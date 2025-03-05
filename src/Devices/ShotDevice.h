#pragma once

#include <QTimer>
#include <QElapsedTimer>

#include "Device.h"

class ShotDevice : public Device
{
    Q_OBJECT
    QSM_WRITABLE_CSTREF_PROPERTY_WDEFAULT( QString, comPort, ComPort, "" ) //ComPort устройства
    QSM_WRITABLE_CSTREF_PROPERTY_WDEFAULT( QString, colorType, ColorType, "" )
    QSM_WRITABLE_VAR_PROPERTY_WDEFAULT( int, dmx, Dmx, 0 ) //DMX
    QSM_WRITABLE_VAR_PROPERTY_WDEFAULT( int, rfChannel, RfChannel, 0 ) //DMX
    QSM_WRITABLE_VAR_PROPERTY_WDEFAULT( int, rfPosition, RfPosition, 0 ) //DMX
    QSM_WRITABLE_VAR_PROPERTY_WDEFAULT( int, height, Height, 0 ) //DMX
    QSM_WRITABLE_VAR_PROPERTY_WDEFAULT( int, angle, Angle, 0 ) //DMX
    QSM_READONLY_VAR_PROPERTY_WDEFAULT( qulonglong, prefireDuration, PrefireDuration, 0 )

public:
    explicit ShotDevice( DeviceManager* mng, QObject* parent = nullptr );

    qulonglong getPrefire() const override { return prefireDuration(); }
    void setPrefire( qulonglong prefire ) override { setPrefireDuration( prefire ); }

    void copyToCueContent( CueContent& cueContent ) const override;

public slots:
    //void onPlaybackTimeChanged( quint64 time );
    void onPatternTimerChanged();

private:
    void doPlaybackTimeChanged( quint64 time, bool sendToWorker );

    void runPatternSingly( const Pattern& p, quint64 time ) override { qCritical() << "not used"; }
    void runActionSingly( const QString& cueName, const Action& action, quint64 time ) override;
    void finishChangeAngle( int angle ) override {};

    qulonglong calcDurationByPattern( const Pattern& pattern ) const override;

    void setDMXOperation( int deviceId, const Operation* op, bool sendToWorker ) override;

private:
    QList<Operation*> m_operations;
    Operation* m_op = nullptr;
    quint64 m_opStartTime = 0;
    quint64 m_patternTime = 0;
    QTimer m_patternTimer;
    QElapsedTimer m_elapsedTimer;
};
