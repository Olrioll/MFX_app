#pragma once

#include <QtCore/QObject>
#include <QtCore/QUuid>

#include "QQmlObjectListModel.h"
#include <QQmlConstRefPropertyHelpers.h>
#include <QQmlVarPropertyHelpers.h>
#include <QSuperMacros.h>

#include "SequenceDevice.h"

class Group : public QObject {
    Q_OBJECT
    QSM_READONLY_CSTREF_PROPERTY(QUuid, id, Id) //Уникальный идентификатор группы
    QSM_WRITABLE_CSTREF_PROPERTY_WDEFAULT(QString, name, Name, "") //Имя группы
    QML_OBJMODEL_PROPERTY(Device, devices) //Устройства в группе
public:
    explicit Group(QObject* parent = nullptr);
};
