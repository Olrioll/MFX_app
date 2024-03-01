#pragma once

#include <QtCore/QObject>
#include <QtCore/QUuid>

#include <QSuperMacros.h>
#include <QQmlVarPropertyHelpers.h>
#include <QQmlEnumClassHelper.h>
#include <QQmlConstRefPropertyHelpers.h>

class CueContent : public QObject
{
    Q_OBJECT

    QSM_READONLY_VAR_PROPERTY(QUuid, uuid, Uuid)
    QSM_READONLY_VAR_PROPERTY_WDEFAULT(qulonglong, delay, Delay, -1) //Задержка от начала Cue до конкретной Operation (В терминологии домена Action). Редактируется.
    QSM_READONLY_VAR_PROPERTY_WDEFAULT(qulonglong, between, Between, -1) //Задержка от начала Cue до конретной Operation за вычетом Delay предыдущей точки. Редактируется.
    QSM_READONLY_VAR_PROPERTY_WDEFAULT(int, rfChannel, RfChannel, -1) //RfChannel для конкретного устройства. Не редактируется.
    QSM_READONLY_VAR_PROPERTY_WDEFAULT(int, device, Device, -1) //Имя устройства - складвается из типа (Sequence, Pyro ...) и порядкового номера устройства. Не редактируется.
    QSM_READONLY_VAR_PROPERTY_WDEFAULT(uint, dmxSlot, DmxSlot, -1) //Слот DMX, используемый для устройства. Не редактируется.
    QSM_READONLY_CSTREF_PROPERTY_WDEFAULT(QString, action, Action, "-") //Действие. По факту это имя Patterna - меняется только перетаскиванием паттерна на плашку устройства (Недоступен для сущностей Pyro и Shot)
    QSM_READONLY_CSTREF_PROPERTY_WDEFAULT(QString, effect, Effect, "-") //То же самое, что и action, только для устройств Pyro - в остальных случаях заблокировано
    QSM_READONLY_VAR_PROPERTY_WDEFAULT(int, angle, Angle, -1) //Угол - доступен только для устройст Pyro. В остальных случаях прочерки
    QSM_READONLY_VAR_PROPERTY_WDEFAULT(qulonglong, time, Time, -1) //Время - не редактируемый параметр для Sequnce и Pyro, для Dimmer и Shot - редактируемый
    QSM_READONLY_VAR_PROPERTY_WDEFAULT(qulonglong, prefire, Prefire, -1) //Префайер - не редактируемый параметр для Sequnce и Pyro, для Dimmer и Shot - редактируемый

    //Декораторы
    QSM_READONLY_CSTREF_PROPERTY_WDEFAULT(QString, delayTimeDecorator, DelayTimeDecorator, "") //Декоратор для времени delay
    QSM_READONLY_CSTREF_PROPERTY_WDEFAULT(QString, betweenTimeDecorator, DurationTimeDecorator, "") //Декоратор для времени between
    QSM_READONLY_CSTREF_PROPERTY_WDEFAULT(QString, timeTimeDecorator, TimeTimeDecorator, "") //Декоратор для времени time
    QSM_READONLY_CSTREF_PROPERTY_WDEFAULT(QString, prefireTimeDecorator, PrefireTimeDecorator, "") //Декоратор для времени prefire

    //Интерфейс
    QSM_READONLY_VAR_PROPERTY_WDEFAULT(bool, selected, Selected, false) //Определяет, быбрана ли данная строка в интерфейсе таблицы Cue Content (Либо массовым выделением Even-Uneven, либо вручную)
    QSM_READONLY_VAR_PROPERTY_WDEFAULT(bool, active, Active, false) //Определяет статус, активен ли сейчас данный паттерн на данном устройстве
public:
    explicit CueContent(QObject *parent = nullptr);

private:
    void initConnections();
    void onActiveChanged(bool active);
};
