#pragma once

#include <QtCore/QObject>

#include "Cue.h"
#include "QQmlObjectListModel.h"

class CueManager : public QObject
{
    Q_OBJECT
    QML_OBJMODEL_PROPERTY(Cue, cues)
    QSM_WRITABLE_VAR_PROPERTY_WDEFAULT(quint64, playerPosition, PlayerPosition, 0)

public:
    explicit CueManager(QObject *parent = nullptr);
    Q_INVOKABLE void addCue(QVariantMap properties);
    Q_INVOKABLE void setActionProperty(QString cueName, QString pattern, int patchId, quint64 newPosition);

public slots:
    void onPlaybackTimeChanged(quint64 time);

private:
    Cue* getCue(QString name);
    Action* getAction(QString cueName, int actId);
    void addActionToCue(QString cueName, QString pattern, int patchId, quint64 newPosition);
};
