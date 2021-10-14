#pragma once

#include <QtCore/QObject>

#include <QSuperMacros.h>
#include <QQmlVarPropertyHelpers.h>
#include <QQmlPtrPropertyHelpers.h>
#include "QQmlObjectListModel.h"

#include "Cue.h"
#include "DmxWorker.h"
#include "CueContentManager.h"
#include "DeviceManager.h"

class CueSortingModel;

class CueManager : public QObject
{
    Q_OBJECT
    QML_OBJMODEL_PROPERTY(Cue, cues)
    QSM_WRITABLE_VAR_PROPERTY_WDEFAULT(quint64, playerPosition, PlayerPosition, 0)
    Q_PROPERTY(CueSortingModel * cuesSorted READ cuesSorted CONSTANT)
public:
    explicit CueManager(CueContentManager& cueContentManager, QObject* parent = nullptr);
    ~CueManager();

    Q_INVOKABLE void cueNameChangeRequest(const QUuid& id, const QString& name); //Обработчик запроса на смену имени из панели списка Cue
    Q_INVOKABLE void collapseCueOnPlayerRequest(const QString& name); //Обработчик запроса из плеера о свертывании(схлопывании) элемента Cue
    Q_INVOKABLE void expandCueOnPlayerRequest(const QString& name); //Обработчик запроса от плеера, что нужно развернуть конкретный элемент Cue
    Q_INVOKABLE void cueSelectedOnCueListRequest(const QString& name); //Обработчик запроса от панели списка Cue о том, что была выделена конкретная Cue
    Q_INVOKABLE void cueDeselectedOnCueListRequest(const QString& name); //Обработчик запроса от панели списка Cue, что у Cue, на которой ранее было выделение, оно снято
    Q_INVOKABLE void deleteCues(QStringList deletedCueNames);

    Cue* cueById(const QUuid& id) const;
    Cue* cueByName(const QString& name) const;

    CueSortingModel* cuesSorted() const;

    void initConnections();

    Action* getAction(const QString &cueName, int deviceId);

    DeviceManager *m_deviceManager;

public slots:
    void onAddCue(QVariantMap properties);
    void onSetActionProperty(const QString &cueName, const QString &pattern, int deviceId, quint64 newPosition);
    void onPlaybackTimeChanged(quint64 time);

signals:
    void runPattern(int deviceId, quint64 time, QString patternName);

    void cueExpandedChanged(const QString& name, bool selected); //Сигнал о том, что у Cue с именем name требуется изменить статус схлопывания на плеере

private:

    void addActionToCue(const QString &cueName, const QString &pattern, int deviceId, quint64 newPosition);
    void recalculateCueStartAndDuration(const QString &cueName);

private:
    CueSortingModel* m_cuesSorted = nullptr;
    CueContentManager& m_cueContentManager;
};
