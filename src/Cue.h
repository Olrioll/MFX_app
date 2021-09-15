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
    QSM_READONLY_VAR_PROPERTY_WDEFAULT(qulonglong, startTime, StartTime, 0) //Время начала Cue в миллисекундах(время самого раннего Action)
    QSM_READONLY_VAR_PROPERTY_WDEFAULT(qulonglong, durationTime, DurationTime, 0) //Длительность Cue в миллисекундах
    QSM_READONLY_VAR_PROPERTY_WDEFAULT(bool, active, Active, false) //Определяет активен ли Cue (идет проигрывание)

    //Декораторы
    QSM_READONLY_CSTREF_PROPERTY_WDEFAULT(QString, startTimeDecorator, StartTimeDecorator, "") //Декоратор для времени начала Cue
    QSM_READONLY_CSTREF_PROPERTY_WDEFAULT(QString, durationTimeDecorator, DurationTimeDecorator, "") //Декоратор для времени начала Cue

    //Интерфейс
    QSM_READONLY_VAR_PROPERTY_WDEFAULT(bool, selected, Selected, false) //Выделен ли Cue на панели списка Cue пользователем
    QSM_READONLY_VAR_PROPERTY_WDEFAULT(bool, expanded, Expanded, false) //Развернута ли Cue на плеере

    QSM_WRITABLE_CSTREF_PROPERTY_WDEFAULT(quint64, stopActiveTime, StopActiveTime, 0) //Время, когда заканчивается проигрывание текущего паттерна

public:
    explicit Cue(QObject *parent = nullptr);

    void initConnections();

private:
    void calculateStartTime();
    void onActiveChanged(bool active);
};
