#ifndef DMXWORKER_H
#define DMXWORKER_H

#include <QSerialPort>
#include <QTimer>
#include <QFile>
#include <QMediaPlayer>
#include <QDebug>

class DMXWorker : public QSerialPort
{
    Q_OBJECT
public:
    static DMXWorker *instance();

public slots:
    void onComPortChanged(QString port);
    void onPlayerStateChanged(QMediaPlayer::State state);
    void onPlaybackTimeChanged();

signals:
    void playbackTimeChanged();
    void startDMXLoop();
    void stopDMXLoop();

private slots:
    void onBytesWritten(qint64 bytes);
    void onError(QSerialPort::SerialPortError error);

private:
    void onStartDMXLoop();
    void onStopDMXLoop();
    explicit DMXWorker(QObject *parent = nullptr);
};

#endif // DMXWORKER_H
