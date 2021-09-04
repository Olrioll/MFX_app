#pragma once

#include <QtCore/QObject>

#include "Cue.h"
#include "QQmlObjectListModel.h"

class CueManager : public QObject
{
    Q_OBJECT
    QML_OBJMODEL_PROPERTY(Cue, cues)
public:
    explicit CueManager(QObject *parent = nullptr);

public slots:
    void onPlaybackTimeChanged(unsigned time); // todo: connect to WaveformWidget
};
