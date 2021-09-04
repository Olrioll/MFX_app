#pragma once

#include <QtCore/QObject>
#include <QtCore/QUuid>

#include <QSuperMacros.h>
#include <QQmlConstRefPropertyHelpers.h>
#include <QQmlVarPropertyHelpers.h>

class Device  : public QObject {
    Q_OBJECT
    QSM_READONLY_CSTREF_PROPERTY(QUuid, id, Id) //Уникальный идентификатор устройства
    QSM_WRITABLE_CSTREF_PROPERTY_WDEFAULT(QString, name, Name, "") //Имя устройства
    QSM_WRITABLE_VAR_PROPERTY(int, x, X) //X-Координата устройства на картинке сцены
    QSM_WRITABLE_VAR_PROPERTY(int, y, Y) //Y-Координата устройства на картинке сцены
    QSM_WRITABLE_VAR_PROPERTY(bool, draggingBlocked, DraggingBlocked) //Флаг, определяющий возможность двигать устройства на сцене
public:
    explicit Device(QObject* parent = nullptr);

    enum class ComPortWinOS : int {
        COM_PORT_UNKNOWN,
        COM1,
        COM2,
        COM3,
        COM4,
        COM5,
        COM6,
        COM7,
        COM8,
        COM9,
        COM10,
        COM11,
        COM12,
        COM13,
        COM14,
        COM15,
        COM16,
        COM17,
        COM18,
        COM19,
        COM20,
    };
    Q_ENUM(ComPortWinOS);

    virtual void runPattern(int num) = 0;
};
