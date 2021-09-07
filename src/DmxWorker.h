#ifndef DMXWORKER_H
#define DMXWORKER_H

#include <QSerialPort>
#include <QTimer>
#include <QFile>
#include <QDebug>

class DMXWorker : public QSerialPort
{
    Q_OBJECT
public:
    static DMXWorker *instance();

public slots:
    void onComPortChanged(QString port);

signals:
    void portChanged(QString port);

private slots:
    void onPortChanged(QString port);
    void onBytesWritten(qint64 bytes);
    void onError(QSerialPort::SerialPortError error);
    void onReadyRead();

private:
    explicit DMXWorker(QObject *parent = nullptr);
    QString m_port;
};

#endif // DMXWORKER_H
