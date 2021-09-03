#ifndef GROUP_H
#define GROUP_H

#include <QDebug>
#include "Device.h"

class Group : public QObject
{
    Q_OBJECT
public:
    explicit Group(QObject *parent = nullptr);

signals:

private:
    int id;
    QString name;
    QList<QSharedPointer<Device>> _devices;
};

#endif // GROUP_H
