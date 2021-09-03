#ifndef DEVICE_H
#define DEVICE_H

#include <QDebug>

class Device : public QObject
{
    Q_OBJECT
public:
    explicit Device(QObject *parent = nullptr);
    virtual void runPattern(int num) = 0;

signals:
protected:
    int id;
    QString name;
    int x;
    int y;
    bool uiBlocked;
};

#endif // DEVICE_H
