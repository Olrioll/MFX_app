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
}
