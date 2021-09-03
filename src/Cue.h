#ifndef CUE_H
#define CUE_H

#include <QDebug>
#include "Action.h"

class Cue : public QObject
{
    Q_OBJECT
public:
    explicit Cue(QObject *parent = nullptr);

signals:

private:
    int id;
    QString name;
    unsigned startTime;
    unsigned duration;
    QList<Action> _actions;
};

#endif // CUE_H
