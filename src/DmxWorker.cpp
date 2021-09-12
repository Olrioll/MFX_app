#include "DmxWorker.h"

DMXWorker::DMXWorker(QObject *parent): QSerialPort(parent)
{
    connect(this, &QSerialPort::bytesWritten, this, &DMXWorker::onBytesWritten);
    connect(this, &QSerialPort::errorOccurred, this, &DMXWorker::onError);
    connect(this, &DMXWorker::playbackTimeChanged, this, &DMXWorker::onPlaybackTimeChanged);
    connect(&m_timer, &QTimer::timeout, this, &DMXWorker::onTimer);
    setBaudRate(115200/*250000*/);
    setDataBits(DataBits::Data8);
    setStopBits(StopBits::OneStop/*StopBits::TwoStop*/);
    setParity(Parity::NoParity);
    setFlowControl(FlowControl::NoFlowControl);
    m_timer.setInterval(10);
    m_timer.start();
}

void DMXWorker::reopenComPort()
{
    if(isOpen()) {
        close();
    }
    const bool result = open(QIODevice::ReadWrite);
    if(!result) {
        qDebug() << "DMXWorker::reopenComPort:" << tr("Error: %1 (port %2)").arg(errorString()).arg(portName());
    } else {
        qDebug() << "DMXWorker::reopenComPort:" << tr("Port %1 opened").arg(portName());
    }
}

DMXWorker *DMXWorker::instance()
{
    static DMXWorker inst;
    return &inst;
}

void DMXWorker::setOperation(int deviceId, Operation *op)
{
    qDebug() << tr("Time: %1, deviceId: %2, duration: %3, angle: %4 (degrees: %5), velocity: %6, active: %7")
                .arg(m_playbackTime).arg(deviceId).arg(op->duration()).arg(op->angle())
                .arg(op->angleDegrees()).arg(op->velocity()).arg(op->active());
    // DMXWorker::instance()->write(QByteArray::fromHex(QVariant("DEADBEAF").toByteArray())); // todo: send simple DMX512 commands
}

void DMXWorker::onComPortChanged(QString port)
{
    setPortName(port);
    reopenComPort();
}

void DMXWorker::onPlayerStateChanged(QMediaPlayer::State state)
{
    if(state == QMediaPlayer::PlayingState) {
        m_processing = true;
        m_timer.stop();
    } else {
        m_processing = false;
        m_playbackTime = 0;
        m_timer.start();
    }
    reopenComPort();
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

    QByteArray writeData("\x00",1);
    QByteArray writeDMXArray = QByteArray::fromHex(QVariant("FF").toByteArray());
    if(!isOpen()) {
        reopenComPort();
    }
    // m_playbackTime
    if(m_processing) {
        write(writeDMXArray);
    } else {
        write(writeData);
    }
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
    }
}

