#ifndef CUEMANAGER_H
#define CUEMANAGER_H

#include <QDebug>
#include "Cue.h"

class CueManager : public QObject
{
    Q_OBJECT
public:
    explicit CueManager(QObject *parent = nullptr);

public slots:
    void onPlaybackTimeChanged(unsigned time); // todo: connect to WaveformWidget

signals:

private:
    QList<Cue> _cues;
};

#endif // CUEMANAGER_H
