#ifndef DMXPLUGIN_H
#define DMXPLUGIN_H

#include <QObject>
#include "DMXDevice.h"
//#include "DMXWriter.h"

class QDmxUsbPlugin : public QObject
{
    Q_OBJECT

public:
    QDmxUsbPlugin(QObject* parent = 0);
    ~QDmxUsbPlugin();
    QString errorString();
    bool outputIsOpened(quint32 device, quint32 port) const;
    virtual void init();

public slots:
    virtual void rescanDevices();
    virtual void writeDmx(quint32 device, quint32 port, QByteArray data);
    virtual void onStopWrite();
    virtual void onChangeWriteData();

public:
    virtual QMap<quint32, DMXDevice*> getDevices() {return m_deviceList;}

signals:
    void rescanDevicesFinished();
    void startWrite(DMXDevice * device);
    void stopWriting();
    void changeWritingData(QByteArray newData);


public:
    virtual bool openOutput(quint32 device, quint32 port);
    virtual bool closeOutput(quint32 device, quint32 port);


private:
    QMap<quint32, DMXDevice*> m_deviceList;
    QMultiHash<quint32,quint32> m_openedOutput;
    QString m_lastError;
    //QDMXWriter *m_writer = NULL;
};

#endif // DMXPLUGIN_H
