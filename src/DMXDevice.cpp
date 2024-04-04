#include "DMXDevice.h"

DMXDevice::DMXDevice(const QString& serial, const QString& name, const QString& vendor, quint16 VID, quint16 PID, quint32 id) :
    m_serial(serial),
    m_name(name),
    m_vendor(vendor),
    m_vendorID(VID),
    m_productID(PID),
    m_id(id),
    m_status(FT_OK),
    m_handle(0)
{

}

DMXDevice::~DMXDevice()
{
    if (isOpen())
        close();
}

QList<DMXDevice*> DMXDevice::devices(QList<DMXDevice*> found)
{
    QList<DMXDevice*> r;
    DWORD nbreDev = 0;
    FT_STATUS status = 0;

    if ((status = FT_CreateDeviceInfoList(&nbreDev)) != FT_OK)
    {
        return r;
    }


    //browse device list
    for (uint i = 0; i < nbreDev; i++)
    {
        QString vendor, description, serial;
        quint16 vid, pid;

        //If it can get info (so if it can work with this app, not belong to another)
        if ((status = getDeviceInfo(i, vendor, description, serial, vid, pid)) != FT_OK)
        {
            continue;
        }

        //If it is a valid device and it is not already found, then add it.
        if (validDevice(vid, pid))
        {
            bool exists = false;
            for (int i = 0; i < found.length() && !exists; i++)
                exists |= found[i]->checkInfo(serial, description, vendor);

            if (!exists)
                r << new DMXDevice(serial, description, vendor, vid, pid, i);
        }
    }

    return r;
}

bool DMXDevice::validDevice(quint16 vendor, quint16 product)
{
    if (vendor != DMXDevice::FTDIVID &&
        vendor != DMXDevice::ATMELVID &&
        vendor != DMXDevice::MICROCHIPVID)
        return false;

    if (product != DMXDevice::FTDIPID &&
        product != DMXDevice::DMX4ALLPID &&
        product != DMXDevice::NANODMXPID &&
        product != DMXDevice::EUROLITEPID &&
        product != DMXDevice::ELECTROTASPID)
        return false;

    return true;
}

bool DMXDevice::checkInfo(const QString& serial, const QString& name, const QString& vendor)
{
    if (m_serial == serial && m_name == name && m_vendor == vendor) {
        return true;
    }
    return false;
}

bool DMXDevice::open()
{
    if (isOpen()) {
        return true;
    }

    if ((m_status = FT_Open(id(), &m_handle)) != FT_OK)
    {
        return false;
    }

    return true;
}

bool DMXDevice::close()
{
    if (!isOpen())
        return true;

    if ((m_status = FT_Close(m_handle)) != FT_OK)
    {
        return false;
    }

    m_handle = 0;

    return true;
}

bool DMXDevice::isOpen() const
{
    return m_handle != 0;
}

bool DMXDevice::setLineProperties()
{
    if ((m_status = FT_SetDataCharacteristics(m_handle, FT_BITS_8, FT_STOP_BITS_2, FT_PARITY_NONE)) != FT_OK)
    {
        return false;
    }

    return true;
}

bool DMXDevice::setBaudRate()
{
    if ((m_status = FT_SetBaudRate(m_handle, 250000)) != FT_OK)
    {
        return false;
    }

    return true;
}

bool DMXDevice::setBreak(bool on)
{
    if (on)  m_status = FT_SetBreakOn(m_handle);
    else    m_status = FT_SetBreakOff(m_handle);

    if (m_status != FT_OK)
    {
        return false;
    }

    return true;
}

bool DMXDevice::write(const QByteArray& data)
{
    DWORD bytesWritten;

    if ((m_status = FT_Write(m_handle, (LPVOID)data.data(), data.size(), &bytesWritten)) != FT_OK)
    {
        return false;
    }

    return true;
}

QString DMXDevice::errorString(FT_STATUS status)
{
    switch (status)
    {
    case FT_OK: return "FT_OK";
    case FT_INVALID_HANDLE: return "FT_INVALID_HANDLE";
    case FT_DEVICE_NOT_FOUND: return "FT_DEVICE_NOT_FOUND";
    case FT_DEVICE_NOT_OPENED: return "FT_DEVICE_NOT_OPENED";
    case FT_IO_ERROR: return "FT_IO_ERROR";
    case FT_INSUFFICIENT_RESOURCES: return "FT_INSUFFICIENT_RESOURCES";
    case FT_INVALID_PARAMETER: return "FT_INVALID_PARAMETER";
    case FT_INVALID_BAUD_RATE: return "FT_INVALID_BAUD_RATE";
    case FT_DEVICE_NOT_OPENED_FOR_ERASE: return "FT_DEVICE_NOT_OPENED_FOR_ERASE";
    case FT_DEVICE_NOT_OPENED_FOR_WRITE: return "FT_DEVICE_NOT_OPENED_FOR_WRITE";
    case FT_FAILED_TO_WRITE_DEVICE: return "FT_FAILED_TO_WRITE_DEVICE";
    case FT_EEPROM_READ_FAILED: return "FT_EEPROM_READ_FAILED";
    case FT_EEPROM_WRITE_FAILED: return "FT_EEPROM_WRITE_FAILED";
    case FT_EEPROM_ERASE_FAILED: return "FT_EEPROM_ERASE_FAILED";
    case FT_EEPROM_NOT_PRESENT: return "FT_EEPROM_NOT_PRESENT";
    case FT_EEPROM_NOT_PROGRAMMED: return "FT_EEPROM_NOT_PROGRAMMED";
    case FT_INVALID_ARGS: return "FT_INVALID_ARGS";
    case FT_NOT_SUPPORTED: return "FT_NOT_SUPPORTED";
    case FT_OTHER_ERROR: return "FT_OTHER_ERROR";
    default: return "Unknown error";
    }
}

FT_STATUS DMXDevice::getDeviceInfo(DWORD deviceIndex, QString& vendor, QString& description, QString& serial, quint16& VID, quint16& PID)
{
    char cVendor[256];
    char cVendorId[256];
    char cDescription[256];
    char cSerial[256];

    FT_HANDLE handle;

    FT_STATUS status = FT_Open(deviceIndex, &handle);
    if (status != FT_OK)
        return status;

    FT_PROGRAM_DATA pData;
    pData.Signature1 = 0;
    pData.Signature2 = 0xFFFFFFFF;
    pData.Version = 0x00000005;
    pData.Manufacturer = cVendor;
    pData.ManufacturerId = cVendorId;
    pData.Description = cDescription;
    pData.SerialNumber = cSerial;
    status = FT_EE_Read(handle, &pData);
    if (status == FT_OK)
    {
        VID = pData.VendorId;
        PID = pData.ProductId;

        if (pData.ProductId == DMXDevice::DMX4ALLPID)
            vendor = QString("DMX4ALL");
        else
            vendor = QString(cVendor);
        description = QString(cDescription);
        serial = QString(cSerial);
    }

    FT_Close(handle);

    return status;
}
