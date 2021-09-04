#include <QtSerialPort/QSerialPortInfo>
#include "ComPortModel.h"

ComPortModel::ComPortModel(QObject *parent): QStringListModel(parent)
{
    reload();
}

void ComPortModel::reload()
{
    QStringList list;
    foreach(const QSerialPortInfo &info, QSerialPortInfo::availablePorts()) {
        list << info.portName();
    }
    beginResetModel();
    setStringList(list);
    endResetModel();
    emit dataReady();
}
