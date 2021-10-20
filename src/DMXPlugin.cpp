#include "DMXPlugin.h"
#include "DMXDevice.h"

QDmxUsbPlugin::QDmxUsbPlugin(QObject *parent): QObject(parent)
{
    //m_writer = new QDMXWriter();
}

QDmxUsbPlugin::~QDmxUsbPlugin()
{
}

QString QDmxUsbPlugin::errorString()
{
    QString r = m_lastError;
    m_lastError.clear();
    return r;
}

bool QDmxUsbPlugin::outputIsOpened(quint32 device, quint32 port) const
{
    bool result = m_openedOutput.contains(device, port);
    return result;
}

void QDmxUsbPlugin::init()
{
    rescanDevices();
    emit rescanDevicesFinished();
}

void QDmxUsbPlugin::rescanDevices()
{
    qDeleteAll(m_deviceList);
    m_deviceList.clear();

    QList<DMXDevice*> deviceList;

    deviceList << DMXDevice::devices(deviceList);

    int i = 0;
    //for each found device
    foreach (DMXDevice* iface, deviceList)
    {
        m_deviceList[i++] = reinterpret_cast<DMXDevice*>(iface);
    }
}


bool QDmxUsbPlugin::openOutput(quint32 device, quint32 port)
{
    bool opened = false;

    if (device < quint32(m_deviceList.size()))
    {
        m_openedOutput.insert(device, port);
        m_deviceList[device]->open();
        m_deviceList[device]->setBaudRate();
        m_deviceList[device]->setLineProperties();
        m_deviceList[device]->setBreak(false);
    }
    opened = outputIsOpened(device, port);
    return opened;
}

bool QDmxUsbPlugin::closeOutput(quint32 device, quint32 port)
{
    bool closed = false;
    if(device >= quint32(m_deviceList.size())) {
        return false;
    }
    closed = m_deviceList[device]->close();
    return closed;
}

void QDmxUsbPlugin::writeDmx(quint32 device, quint32 port, QByteArray data)
{
    if (device >= quint32(m_deviceList.size())) {
        return;
    }
    /*m_writer->init(m_deviceList[device], data);
    m_writer->start();*/
}

void QDmxUsbPlugin::onStopWrite()
{
   //m_writer->stop();
}

void QDmxUsbPlugin::onChangeWriteData()
{
    QByteArray data;
    data.resize(512);
    data.fill('a', 512);
    //m_writer->changeData(data);
}

