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

    QSM_READONLY_CSTREF_PROPERTY(QUuid, id, Id) //Уникальный идентификатор Cue
    QSM_WRITABLE_CSTREF_PROPERTY_WDEFAULT(QString, name, Name, "") //Имя Cue
    QSM_READONLY_VAR_PROPERTY(qulonglong, startTime, startTime) //Время начала Cue в миллисекундах
    QSM_READONLY_VAR_PROPERTY(qulonglong, duration, Duration) //Длительность Cue в миллисекундах
    QML_OBJMODEL_PROPERTY(Action, actions) //Список Action внутри Cue

public:
    explicit Cue(QObject *parent = nullptr);
};
