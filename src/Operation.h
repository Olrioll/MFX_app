#pragma once

#include <QtCore/QObject>

#include <QSuperMacros.h>
#include <QQmlVarPropertyHelpers.h>

class Operation: public QObject {
    Q_OBJECT
    QSM_READONLY_VAR_PROPERTY(qulonglong, time, Time) //Время срабатывания действия
    QSM_READONLY_VAR_PROPERTY(int, angle, Angle) //Угол срабатывания действия
    QSM_READONLY_VAR_PROPERTY(int, velocity, Velocity) //Скорость срабатывания действия
    QSM_READONLY_VAR_PROPERTY(bool, active, Active) //Активнf ли сейчас операция действия (ex. включен ли огонь)
public:
    explicit Operation(QObject* parent = nullptr);
    Operation(const Operation& operation);

    int angleDegrees() const;
};

