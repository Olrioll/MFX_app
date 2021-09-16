#include "CueContent.h"

#include <QtCore/QTime>

CueContent::CueContent(QObject *parent) : QObject(parent)
{  
    initConnections();
}

void CueContent::initConnections()
{
    connect(this, &CueContent::activeChanged, this, &CueContent::onActiveChanged);

    connect(this, &CueContent::delayChanged, [=](const qulonglong delayTimeValue) {
        QTime newDelayTime(QTime::fromMSecsSinceStartOfDay(delayTimeValue));

        const auto newDelayTimeDecoratedValue = newDelayTime.toString("hh:mm:ss.zzz");
        setDelayTimeDecorator(newDelayTimeDecoratedValue);
    });

    connect(this, &CueContent::betweenChanged, [=](const qulonglong betweenTimeValue) {
        QTime newDurationTime(QTime::fromMSecsSinceStartOfDay(betweenTimeValue));

        const auto newDurationTimeDecoratedValue = newDurationTime.toString("hh:mm:ss.zzz");
        setDurationTimeDecorator(newDurationTimeDecoratedValue);
    });

    connect(this, &CueContent::timeChanged, [=](const qulonglong timeTimeValue) {
        QTime newTimeTime(QTime::fromMSecsSinceStartOfDay(timeTimeValue));

        const auto newTimeTimeDecoratedValue = newTimeTime.toString("hh:mm:ss.zzz");
        setTimeTimeDecorator(newTimeTimeDecoratedValue);
    });

    connect(this, &CueContent::prefireChanged, [=](const qulonglong prefireTimeValue) {
        QTime newPrefireTime(QTime::fromMSecsSinceStartOfDay(prefireTimeValue));

        const auto newPrefireTimeDecoratedValue = newPrefireTime.toString("hh:mm:ss.zzz");
        setPrefireTimeDecorator(newPrefireTimeDecoratedValue);
    });
}

void CueContent::onActiveChanged(bool active)
{
    qDebug() << "CueContent::onActiveChanged:" << m_device << active;
}
