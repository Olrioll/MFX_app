#include "Cue.h"

#include <QtCore/QTime>

Cue::Cue(QObject *parent) : QObject(parent)
{
    setUuid(QUuid::createUuid());
    m_actions = new QQmlObjectListModel<Action>(this);

    initConnections();
}

void Cue::initConnections()
{
    connect(this, &Cue::startTimeChanged, [=](const qulonglong newStartTimeValue) {
        QTime newStartTime(QTime::fromMSecsSinceStartOfDay(newStartTimeValue));

        const auto newStartTimeDecoratedValue = newStartTime.toString("hh:mm:ss.zzz");
        setStartTimeDecorator(newStartTimeDecoratedValue);
    });

    connect(this, &Cue::durationTimeChanged, [=](const qulonglong newDurationTimeValue) {
        QTime newDurationTime(QTime::fromMSecsSinceStartOfDay(newDurationTimeValue));

        const auto newDurationTimeDecoratedValue = newDurationTime.toString("hh:mm:ss.zzz");
        setDurationTimeDecorator(newDurationTimeDecoratedValue);
    });

    //Пришел запрос от плеера, что изменилось развертывание Cue в плеере
    connect(this, &Cue::expandedChanged, this, &Cue::setSelected);

    //Пришел запрос с панели списка Cue, что изменилось выделение Cue
    //Здесь дублировании функционала переменных Selected и Expande, чтобы указать,
    //что они отвечают за разные панели в интерфейсе
    connect(this, &Cue::selectedChanged, this, &Cue::setExpanded);
}
