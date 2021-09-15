#pragma once

#include <QtCore/QObject>

#include "QQmlObjectListModel.h"
#include "QQmlPtrPropertyHelpers.h"
#include "QQmlEnumClassHelper.h"
#include <QSuperMacros.h>

#include "CueContent.h"
#include "Cue.h"
#include "DeviceManager.h"

QSM_ENUM_CLASS(CueContentSelectedTableRole, Delay = 0)
QSM_ENUM_CLASS(CalculatorOperator, Unknown = -1)
QSM_ENUM_CLASS(TimeUnit, MSec = 0, Sec, Min )

class CueContentManager : public QObject {
    Q_OBJECT
    QML_OBJMODEL_PROPERTY(CueContent, cueContentItems) //Модель всех элементов СueContent
    QSM_READONLY_PTR_PROPERTY_WDEFAULT(Cue, currentCue, CurrentCue, nullptr) //Текущая выбранная Cue
public:
    explicit CueContentManager(DeviceManager& deviceManager, QObject* parent = nullptr);

    Q_INVOKABLE void onUpdateCueContentValueRequest(CueContentSelectedTableRole::Type selectedRole, CalculatorOperator::Type calculatorOperator, int value, TimeUnit::Type timeUnit);

private:
    void initConnections();
    void refrestCueContentModel();

private:
    DeviceManager& m_deviceManager;
};
