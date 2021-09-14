#pragma once

#include <QtCore/QObject>

#include <QSuperMacros.h>
#include <QQmlVarPropertyHelpers.h>
#include <QQmlPtrPropertyHelpers.h>
#include "QQmlObjectListModel.h"

#include "Cue.h"
#include "DmxWorker.h"
#include "CueContentManager.h"

class CueSortingModel;

class CueManager : public QObject
{
    Q_OBJECT
    QML_OBJMODEL_PROPERTY(Cue, cues)
    QSM_WRITABLE_VAR_PROPERTY_WDEFAULT(quint64, playerPosition, PlayerPosition, 0)
    Q_PROPERTY(CueSortingModel * cuesSorted READ cuesSorted CONSTANT)
public:
    explicit CueManager(CueContentManager& cueContentManager, QObject *parent = nullptr);
    ~CueManager();

    Q_INVOKABLE void addCue(QVariantMap properties);
    Q_INVOKABLE void setActionProperty(const QString &cueName, const QString &pattern, int deviceId, quint64 newPosition);

    Q_INVOKABLE void cueNameChangeRequest(const QUuid & id, const QString & name); //Обработчик запроса на смену имени из панели списка Cue

    Cue * cueById(const QUuid & id) const;

    CueSortingModel * cuesSorted() const;

    void initConnections();

public slots:
    void onPlaybackTimeChanged(quint64 time);

signals:
    void runPattern(int deviceId, quint64 time, QString patternName);

private:
    Cue* getCue(const QString &name);
    Action* getAction(const QString &cueName, int deviceId);
    void addActionToCue(const QString &cueName, const QString &pattern, int deviceId, quint64 newPosition);

private:
    CueSortingModel * m_cuesSorted = nullptr;
    CueContentManager& m_cueContentManager;
};
