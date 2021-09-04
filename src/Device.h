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

    virtual void runPattern(int num) = 0;
};
