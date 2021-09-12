#ifndef DMXWORKER_H
#define DMXWORKER_H

#include <QSerialPort>
#include <QTimer>
#include <QFile>
#include <QMediaPlayer>
#include <QDebug>
#include "Operation.h"
#include "QThread"

class DMXWorker : public QSerialPort
{
    Q_OBJECT
public:
    static DMXWorker *instance();
    void setOperation(int deviceId, Operation* op);

public slots:
    void onComPortChanged(QString port);
    void onPlayerStateChanged(QMediaPlayer::State state);
    void onPlaybackTimeChanged(quint64 time);
    void onTimer();

signals:
    void playbackTimeChanged(quint64 time);

private slots:
    void onBytesWritten(qint64 bytes);
    void onError(QSerialPort::SerialPortError error);

private:
    QTimer m_timer;
    quint64 m_playbackTime;
    QByteArray m_dmxArray;
    explicit DMXWorker(QObject *parent = nullptr);
    void openComPort();
};

#endif // DMXWORKER_H
