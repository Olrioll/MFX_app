#pragma once

#include <QtCore/QObject>
#include <QtCore/QUuid>

#include <QSuperMacros.h>
#include <QQmlVarPropertyHelpers.h>
#include <QQmlConstRefPropertyHelpers.h>
#include "QQmlObjectListModel.h"

#include "Action.h"

class Cue : public QObject
{
    Q_OBJECT

    QSM_READONLY_CSTREF_PROPERTY(QUuid, uuid, Uuid) //Уникальный идентификатор Cue
    QSM_WRITABLE_CSTREF_PROPERTY_WDEFAULT(QString, name, Name, "") //Имя Cue
    QML_OBJMODEL_PROPERTY(Action, actions) //Список Action внутри Cue
    QSM_READONLY_VAR_PROPERTY_WDEFAULT(qulonglong, startTime, StartTime, 0) //Время начала Cue в миллисекундах
    QSM_READONLY_VAR_PROPERTY_WDEFAULT(qulonglong, duration, Duration, 0) //Длительность Cue в миллисекундах
    QSM_READONLY_VAR_PROPERTY_WDEFAULT(bool, active, Active, false) //Определяет активен ли Cue (идет проигрывание)

    //Интерфейс
    QSM_WRITABLE_VAR_PROPERTY_WDEFAULT(bool, selected, Selected, false) //Выделен ли Cue в списке пользователем

public:
    explicit Cue(QObject *parent = nullptr);
};
