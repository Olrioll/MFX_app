#include "DmxWorker.h"

DMXWorker::DMXWorker(QObject *parent): QSerialPort(parent)
{
    connect(this, &QSerialPort::bytesWritten, this, &DMXWorker::onBytesWritten);
    connect(this, &QSerialPort::errorOccurred, this, &DMXWorker::onError);
    connect(this, &DMXWorker::playbackTimeChanged, this, &DMXWorker::onPlaybackTimeChanged);
    connect(&m_timer, &QTimer::timeout, this, &DMXWorker::onTimer);
    setBaudRate(250000);
    setDataBits(DataBits::Data8);
    setStopBits(StopBits::TwoStop);
    setParity(Parity::NoParity);
    setFlowControl(FlowControl::NoFlowControl);
    m_timer.setInterval(10);
    m_dmxArray.fill(0x0, 512);
    m_timer.start();
}

void DMXWorker::openComPort()
{
    if(portName().isEmpty()) {
        return;
    }
    const bool result = open(QIODevice::ReadWrite);
    if(!result) {
        qDebug() << "DMXWorker::openComPort:" << tr("Error: %1 (port %2)").arg(errorString()).arg(portName());
    } else {
        qDebug() << "DMXWorker::openComPort:" << tr("Port %1 opened").arg(portName());
    }
}

DMXWorker *DMXWorker::instance()
{
    static DMXWorker inst;
    return &inst;
}

void DMXWorker::setOperation(int deviceId, Operation *op)
{
    if(op != NULL) {
        m_dmxArray[(deviceId - 1) * 6] = op->angle(); // first channel
        m_dmxArray[(deviceId - 1) * 6 + 2] = op->active() ? 0xff: 0; // 0 = no fire / 255 = fire
    } else {
        m_dmxArray.fill(0x0, 512);
    }
}

void DMXWorker::onComPortChanged(QString port)
{
    close();
    setPortName(port);
    openComPort();
}

void DMXWorker::onPlayerStateChanged(QMediaPlayer::State state)
{
    if(state == QMediaPlayer::PlayingState) {
        m_timer.stop();
    } else {
        m_playbackTime = 0;
        m_timer.start();
    }
}

void DMXWorker::onPlaybackTimeChanged(quint64 time)
{
    m_playbackTime = time;
    onTimer();
}

void DMXWorker::onTimer()
{
#if defined(Q_OS_LINUX)
    return;
#endif

    if(portName().isEmpty()) {
        return;
    }
    if(!isOpen()) {
        openComPort();
    }
    QByteArray singleZero("\x00",1);
    setBaudRate(96000);
    write(singleZero);
    setBaudRate(250000);
    write(m_dmxArray);
}

void DMXWorker::onBytesWritten(qint64 bytes)
{
    Q_UNUSED(bytes);
    //qDebug() << "DMXWorker::onBytesWritten:" << tr("%1 bytes written").arg(bytes);
}

void DMXWorker::onError(QSerialPort::SerialPortError error)
{
    if (error == QSerialPort::WriteError) {
        qDebug() << "DMXWorker::onError:" << tr("Error: %1 (port %2)").arg(errorString().arg(portName()));
        close();
    }
}

