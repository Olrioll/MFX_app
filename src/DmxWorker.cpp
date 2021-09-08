#include "DmxWorker.h"

DMXWorker::DMXWorker(QObject *parent): QSerialPort(parent)
{
    connect(this, &QSerialPort::bytesWritten, this, &DMXWorker::onBytesWritten);
    connect(this, &QSerialPort::errorOccurred, this, &DMXWorker::onError);
    connect(this, &DMXWorker::startDMXLoop, this, &DMXWorker::onStartDMXLoop);
    connect(this, &DMXWorker::stopDMXLoop, this, &DMXWorker::onStopDMXLoop);
    connect(this, &DMXWorker::playbackTimeChanged, this, &DMXWorker::onPlaybackTimeChanged);
    setBaudRate(115200/*250000*/);
    setDataBits(DataBits::Data8);
    setStopBits(StopBits::OneStop/*StopBits::TwoStop*/);
    setParity(Parity::NoParity);
    setFlowControl(FlowControl::NoFlowControl);
}

DMXWorker *DMXWorker::instance()
{
    static DMXWorker inst;
    return &inst;
}

void DMXWorker::onComPortChanged(QString port)
{
    setPortName(port);
}

void DMXWorker::onPlayerStateChanged(QMediaPlayer::State state)
{
    if(state == QMediaPlayer::PlayingState) {
        emit startDMXLoop();
    } else {
        emit stopDMXLoop();
    }
}

void DMXWorker::onPlaybackTimeChanged()
{
    QByteArray writeData = QByteArray::fromHex(QVariant("00").toByteArray());
    write(writeData);
}

void DMXWorker::onBytesWritten(qint64 bytes)
{
    //qDebug() << "DMXWorker::onBytesWritten:" << tr("%1 bytes written").arg(bytes);
}

void DMXWorker::onError(QSerialPort::SerialPortError error)
{
    if (error == QSerialPort::WriteError) {
        qDebug() << "DMXWorker::onError:" << tr("Error: %1 (port %2)").arg(errorString().arg(portName()));
    }
}

void DMXWorker::onStartDMXLoop()
{
    if(!isOpen()) {
        const bool result = open(QIODevice::ReadWrite);
        if(!result) {
            qDebug() << "DMXWorker::onStartDMXLoop:" << tr("Error: %1 (port %2)").arg(errorString()).arg(portName());
        } else {
            qDebug() << "DMXWorker::onStartDMXLoop:" << tr("Port %1 opened").arg(portName());
        }
    }
}

void DMXWorker::onStopDMXLoop()
{
    if(isOpen()) {
        close();
    }
    qDebug() << "DMXWorker::onStopDMXLoop";
}

