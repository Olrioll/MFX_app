#pragma once

#include <QtCore/QObject>

#include <QSuperMacros.h>
#include <QQmlVarPropertyHelpers.h>

constexpr int MIN_ANGLE = -105;
constexpr int MAX_ANGLE = 105;

class Operation: public QObject {
    Q_OBJECT
    QSM_READONLY_VAR_PROPERTY(qulonglong, duration, Duration) //Продолжительность операции
    QSM_READONLY_VAR_PROPERTY(int, angle, Angle) //Угол срабатывания действия
    QSM_READONLY_VAR_PROPERTY(int, velocity, Velocity) //Скорость срабатывания действия
    QSM_READONLY_VAR_PROPERTY(bool, active, Active) //Активна ли сейчас операция действия (ex. включен ли огонь)
    QSM_READONLY_VAR_PROPERTY(bool, skipOutOfAngles, SkipOutOfAngles) //Пропускать операцию, если выходит за диапазон углов устройства
public:
    explicit Operation(QObject* parent = nullptr);
    Operation(const Operation& operation);

    int angleDegrees() const;
};

