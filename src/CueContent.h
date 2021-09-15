#pragma once

#include <QtCore/QObject>

#include <QSuperMacros.h>
#include <QQmlVarPropertyHelpers.h>
#include <QQmlEnumClassHelper.h>
#include <QQmlConstRefPropertyHelpers.h>

class CueContent : public QObject
{
    Q_OBJECT
    //Должны быть
    //Указатель на SequenceDevice - можем достать свойства DMX, Device, RFChannel. Time и Prefier мы не испльзуем для SequenceDevice, но как я понял, эти проперти должны быть зашиты там
    //Delay, Between берем это связь конкретной Cue и операций (Operation), то есть понадобится либо сюда давать список операций, либо какой-то OperationManager
    //То есть в итоге нужно:
    //1. SequenceDevice и его ID (только не уникальный, а id)
    //2. Cue - чтобы знать начало
    //3. Operation - конкретная операция, принадлежащая кьюшке
    QSM_READONLY_VAR_PROPERTY_WDEFAULT(qulonglong, delay, Delay, 0) //Задержка от начала Cue до конкретной Operation (В терминологии домена Action). Редактируется.
    QSM_READONLY_VAR_PROPERTY_WDEFAULT(qulonglong, between, Between, 0) //Задержка от начала Cue до конретной Operation за вычетом Delay предыдущей точки. Редактируется.
    QSM_READONLY_VAR_PROPERTY_WDEFAULT(int, rfChannel, RfChannel, 0) //RfChannel для конкретного устройства. Не редактируется.
    QSM_READONLY_VAR_PROPERTY_WDEFAULT(int, device, Device, 0) //Имя устройства - складвается из типа (Sequence, Pyro ...) и порядкового номера устройства. Не редактируется.
    QSM_READONLY_VAR_PROPERTY_WDEFAULT(uint, dmxSlot, DmxSlot, 0) //Слот DMX, используемый для устройства. Не редактируется.
    QSM_READONLY_CSTREF_PROPERTY_WDEFAULT(QString, action, Action, "") //Действие. По факту это имя Patterna - меняется только перетаскиванием паттерна на плашку устройства (Недоступен для сущностей Pyro и Shot)
    QSM_READONLY_CSTREF_PROPERTY_WDEFAULT(QString, effect, Effect, "") //То же самое, что и action, только для устройств Pyro - в остальных случаях заблокировано
    QSM_READONLY_VAR_PROPERTY_WDEFAULT(int, angle, Angle, 0) //Угол - доступен только для устройст Pyro. В остальных случаях прочерки
    QSM_READONLY_VAR_PROPERTY_WDEFAULT(qulonglong, time, Time, 0) //Время - не редактируемый параметр для Sequnce и Pyro, для Dimmer и Shot - редактируемый
    QSM_READONLY_VAR_PROPERTY_WDEFAULT(qulonglong, prefier, Prefier, 0) //Префайер - не редактируемый параметр для Sequnce и Pyro, для Dimmer и Shot - редактируемый

    //Интерфейс
    QSM_READONLY_VAR_PROPERTY_WDEFAULT(bool, selected, Selected, false) //Определяет, быбрана ли данная строка в интерфейсе таблицы Cue Content (Либо массовым выделением Even-Uneven, либо вручную)
    QSM_READONLY_VAR_PROPERTY_WDEFAULT(bool, active, Active, false) //Определяет статус, активен ли сейчас данный паттерн на данном устройстве
public:
    explicit CueContent(QObject *parent = nullptr);

private:
    void onActiveChanged(bool active);
};
