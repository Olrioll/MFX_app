#pragma once

#include <QtCore/QObject>
#include <QtCore/QUuid>

#include <QSuperMacros.h>
#include <QQmlConstRefPropertyHelpers.h>
#include <QQmlVarPropertyHelpers.h>
#include "Pattern.h"

constexpr int PREVIEW_DEVICE_ID = -1;

enum DeviceType {
    DEVICE_TYPE_SEQUENCES,
    DEVICE_TYPE_DIMMER,
    DEVICE_TYPE_SHOT,
    DEVICE_TYPE_PYRO
};

class DeviceManager;

class Device  : public QObject {
    Q_OBJECT
    QSM_READONLY_CSTREF_PROPERTY(QUuid, uuid, Uuid) //Уникальный идентификатор устройства
    QSM_READONLY_CSTREF_PROPERTY(DeviceType, deviceType, DeviceType) // Тип устройства
    QSM_WRITABLE_CSTREF_PROPERTY_WDEFAULT(QString, imageFile, ImageFile, "")  //Путь к файлу в ресурсах, соответствует типу устройства
    QSM_WRITABLE_CSTREF_PROPERTY(int, id, Id)  //Идентификатор устройства
    QSM_WRITABLE_CSTREF_PROPERTY(bool, checked, Checked)  //Флаг: выбрано устройство в интерфейсе или нет
    QSM_WRITABLE_CSTREF_PROPERTY(qreal, posXRatio, PosXRatio)  //Смещение по оси X на картинке сцены (в процентах от размера сцены)
    QSM_WRITABLE_CSTREF_PROPERTY(qreal, posYRatio, PosYRatio)  //Смещение по оси Y на картинке сцены (в процентах от размера сцены)
    QSM_WRITABLE_VAR_PROPERTY(bool, draggingBlocked, DraggingBlocked) //Флаг, определяющий возможность двигать устройства на сцене
public:
    explicit Device(QObject* parent = nullptr);
    //virtual void runPattern(const Pattern* p, quint64 time) = 0;
    virtual void runPatternSingly( const Pattern* p, quint64 time ) = 0;
    virtual void finishChangeAngle( int angle ) = 0;

    DeviceManager *m_manager;
};
