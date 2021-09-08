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
    bool m_processing = false;
    explicit DMXWorker(QObject *parent = nullptr);
    void reopenComPort();
};

#endif // DMXWORKER_H
