#include "DmxWorker.h"

DMXWorker::DMXWorker(QObject *parent): QSerialPort(parent)
{
    connect(this, &QSerialPort::readyRead, this, &DMXWorker::onReadyRead);
    connect(this, &QSerialPort::bytesWritten, this, &DMXWorker::onBytesWritten);
    connect(this, &QSerialPort::errorOccurred, this, &DMXWorker::onError);
    connect(this, &DMXWorker::portChanged, this, &DMXWorker::onPortChanged);
    setBaudRate(250000);
    setDataBits(DataBits::Data8);
    setStopBits(StopBits::TwoStop);
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
    if(isOpen()) {
        close();
    }
    setPortName(port);
    const bool result = open(QIODevice::ReadWrite);
    m_port = result ? port: "";
    emit portChanged(m_port);
}

void DMXWorker::onPortChanged(QString port)
{
    Q_UNUSED(port);
    // todo: start DMX512 protocol loop
    QByteArray writeData = QByteArray::fromHex(QVariant("FFFFFFFFFFFF").toByteArray());
    write(writeData);
}

void DMXWorker::onBytesWritten(qint64 bytes)
{
    qDebug() << "DMXWorker::onBytesWritten:" << tr("%1 bytes written").arg(bytes);
}

void DMXWorker::onError(QSerialPort::SerialPortError error)
{
    if (error == QSerialPort::WriteError) {
        qDebug() << "DMXWorker::onError:" << tr("Error: %1 (port %2)").arg(errorString().arg(portName()));
    }
}

void DMXWorker::onReadyRead()
{
    while(bytesAvailable()) {
        QByteArray bytes = readAll();
        qDebug() << "DMXWorker::onReadyRead:" << bytes.toHex();
    }
}
