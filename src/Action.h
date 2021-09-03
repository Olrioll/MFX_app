#ifndef ACTION_H
#define ACTION_H

#include <QDebug>

class Action : public QObject
{
    Q_OBJECT
public:
    explicit Action(QObject *parent = nullptr);

signals:

private:
    int id;
    int deviceId;
    int startTime; // relative to Cue start time
    int patternNumber;
};

#endif // ACTION_H
