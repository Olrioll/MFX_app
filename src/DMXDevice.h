#ifndef DMXDEVICE_H
#define DMXDEVICE_H

#include <QtCore>
#include "ftd2xx.h"

class DMXDevice
{
public:
    DMXDevice(const QString& serial, const QString& name, const QString& vendor, quint16 VID, quint16 PID, quint32 id = 0);
    ~DMXDevice();
    static QList<DMXDevice*> devices(QList<DMXDevice*> found);
    static bool validDevice(quint16 vendor, quint16 product);
    bool checkInfo(const QString& serial, const QString& name, const QString& vendor);

    /** Get the device's USB name */
    QString name() const { return m_name; }

    /** Get the device's USB vendor ID */
    quint16 vendorID() const { return m_vendorID; }

    /** Get the device's USB product ID */
    quint16 productID() const { return m_productID; }

    /** Get the device's FTD2XX ID number */
    quint32 id() const { return m_id; }

    virtual bool open();
    virtual bool close();
    virtual bool isOpen() const;
    virtual bool setLineProperties();
    virtual bool setBaudRate();
    virtual bool setBreak(bool on);
    virtual bool write(const QByteArray& data);

    static const int FTDIVID = 0x0403;      //! FTDI Vendor ID
    static const int ATMELVID = 0x03EB;     //! Atmel Vendor ID
    static const int MICROCHIPVID = 0x04D8; //! Microchip Vendor ID
    static const int FTDIPID = 0x6001;      //! FTDI Product ID
    static const int DMX4ALLPID = 0xC850;   //! DMX4ALL FTDI Product ID
    static const int NANODMXPID = 0x2018;   //! DMX4ALL Nano DMX Product ID
    static const int EUROLITEPID = 0xFA63;  //! Eurolite USB DMX Product ID
    static const int ELECTROTASPID = 0x0000;//! ElectroTAS USB DMX Product ID

private:
    static QString errorString(FT_STATUS status);
    static FT_STATUS getDeviceInfo(DWORD deviceIndex, QString& vendor, QString& description, QString& serial, quint16& VID, quint16& PID);

private:
    QString m_serial;
    QString m_name;
    QString m_vendor;
    quint16 m_vendorID;
    quint16 m_productID;
    quint32 m_id;
    FT_STATUS m_status;
    FT_HANDLE m_handle;
};

#endif // DMXDEVICE_H
