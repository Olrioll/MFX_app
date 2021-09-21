#pragma once

#include <QtCore/QObject>

#include "QQmlObjectListModel.h"
#include "QQmlConstRefPropertyHelpers.h"
#include "QQmlPtrPropertyHelpers.h"
#include "QQmlEnumClassHelper.h"
#include <QSuperMacros.h>

#include "CueContent.h"
#include "Cue.h"
#include "DeviceManager.h"

QSM_ENUM_CLASS(CueContentSelectedTableRole, Unknown = -1, Delay = 1, Between, DmxChannel, Device, RfChannel, Action, Effect, Angle, Time, Prefire)
QSM_ENUM_CLASS(CalculatorOperator, Add = 0, Substract, Multiply, Divide, Percent)
QSM_ENUM_CLASS(TimeUnit, Milliseconds = 0, Seconds, Minutes)

class CueManager;
class CueContentSortingModel;

class CueContentManager : public QObject {
    Q_OBJECT
    QML_OBJMODEL_PROPERTY(CueContent, cueContentItems) //Модель всех элементов СueContent
    Q_PROPERTY(CueContentSortingModel * cueContentSorted READ cueContentSorted CONSTANT)
    QSM_READONLY_PTR_PROPERTY_WDEFAULT(Cue, currentCue, CurrentCue, nullptr) //Текущая выбранная Cue
    QSM_READONLY_CSTREF_PROPERTY_WDEFAULT(CueContentSelectedTableRole::Type, selectedTableRole, SelectedTableRole, CueContentSelectedTableRole::Unknown) //Текущая выбранная роль в таблице (определяется типом роли в заголовке таблицы)

    //Значения для заголовкой таблицы - по ним также будут определяться параметры метода onUpdateCueContentValueRequest()
    QSM_READONLY_CSTREF_PROPERTY_WDEFAULT(CueContentSelectedTableRole::Type, timingTypeSelectedTableRole, TimingTypeSelectedTableRole, CueContentSelectedTableRole::Delay) //Выбранная роль для типа тайминга (Второй столбец - Delay, Beetween)
    QSM_READONLY_CSTREF_PROPERTY_WDEFAULT(CueContentSelectedTableRole::Type, deviceTypeSelectedTableRole, DeviceTypeSelectedTableRole, CueContentSelectedTableRole::Device) //Выбранная роль данных устройства( Третий столбец - DMXCh, Device, RfChannel)
    QSM_READONLY_CSTREF_PROPERTY_WDEFAULT(CueContentSelectedTableRole::Type, actionTypeSelectedTableRole, ActionTypeSelectedTableRole, CueContentSelectedTableRole::Action) //Выбранная роль данных устройства( Четвертый столбец - Action, Effect, Angle)
    QSM_READONLY_CSTREF_PROPERTY_WDEFAULT(CueContentSelectedTableRole::Type, durationTypeSelectedTableRole, DurationTypeSelectedTableRole, CueContentSelectedTableRole::Time) //Выбранная роль длительности экшена( Пятый столбец - Time, Prefire)

public:
    explicit CueContentManager(DeviceManager& deviceManager, QObject* parent = nullptr);

    Q_INVOKABLE void onUpdateCueContentValueRequest(CueContentSelectedTableRole::Type selectedRole, CalculatorOperator::Type calculatorOperator, int value, TimeUnit::Type timeUnit);

    Q_INVOKABLE void onTimingTypeSelectedTableRoleChangeRequest(const CueContentSelectedTableRole::Type& role);
    Q_INVOKABLE void onDeviceTypeSelectedTableRoleChangeRequest(const CueContentSelectedTableRole::Type& role);
    Q_INVOKABLE void onActionTypeSelectedTableRoleChangeRequest(const CueContentSelectedTableRole::Type& role);
    Q_INVOKABLE void onDurationTypeSelectedTableRoleChangeRequest(const CueContentSelectedTableRole::Type& role);

    Q_INVOKABLE void onSelectAllItemsRequest();
    Q_INVOKABLE void onSelectEvenItemsRequest();
    Q_INVOKABLE void onSelectUnevenItemsRequest();
    Q_INVOKABLE void onSelectLeftItemsRequest();
    Q_INVOKABLE void onSelectRightItemsRequest();

    void setActive(const QString &cueName, int deviceId, bool active);
    CueManager *m_cueManager;

    CueContentSortingModel* cueContentSorted() const;

    static void qmlRegister();
private:
    void initConnections();
    void refrestCueContentModel();
    void updateCueContentDelay(CalculatorOperator::Type calculatorOperator, quint64 value);
    void updateCueContentBetween(CalculatorOperator::Type calculatorOperator, quint64 value);
    void updateCueContentAction(CalculatorOperator::Type calculatorOperator, int value);


private:
    DeviceManager& m_deviceManager;
    CueContentSortingModel * m_cueContentSorted = nullptr;
};
