#include "CueManager.h"

#include <QtCore/QRandomGenerator>

#include "CueSortingModel.h"

CueManager::CueManager(CueContentManager &cueContentManager, QObject *parent) : QObject(parent), m_cueContentManager(cueContentManager)
{
    connect(this, &CueManager::playerPositionChanged, this, &CueManager::onPlaybackTimeChanged);
    m_cues = new QQmlObjectListModel<Cue>(this);
    m_cuesSorted = new CueSortingModel(*m_cues, this);

    initConnections();
}

CueManager::~CueManager()
{
    m_cues->clear();
    m_cues->deleteLater();
}

void CueManager::initConnections()
{
}

Cue *CueManager::getCue(QString name)
{
    Cue* cue = NULL;
    for(const auto & c : m_cues->toList()) {
        if(c->name() == name) {
            cue = c;
            break;
        }
    }
    return cue;
}

Action *CueManager::getAction(QString cueName, int deviceId)
{
    Action *act = NULL;
    Cue* cue = getCue(cueName);
    if(cue == NULL) {
        return NULL;
    }
    for(const auto & a : cue->actions()->toList()) {
        if(a->deviceId() == deviceId) {
            act = a;
            break;
        }
    }
    return act;
}

void CueManager::addCue(QVariantMap properties)
{
    QString name = properties.value("name").toString();
    //double newYposition = properties.value("newYposition").toDouble();
    Cue* newCue = new Cue(this);

    //TODO временно добавил для генерации случайного времени старта и длины кьюшки
    newCue->setStartTime(QRandomGenerator::global()->generate64() % 100000);
    newCue->setDurationTime(QRandomGenerator::global()->generate64() % 100);
    newCue->setName(name);
    m_cues->append(newCue);
}

void CueManager::addActionToCue(QString cueName, QString pattern, int deviceId, quint64 newPosition)
{
    Cue* cue = getCue(cueName);
    if(cue == NULL) {
        return;
    }
    auto actions = cue->actions();
    Action* newAction = new Action(this);
    newAction->setPatternName(pattern);
    newAction->setDeviceId(deviceId);
    quint64 position = newPosition / 10;
    newAction->setStartTime(position * 10);
    actions->append(newAction);

    m_cueContentManager.createCueContentItems(cueName, QString::number(deviceId), pattern);
}

void CueManager::setActionProperty(QString cueName, QString pattern, int deviceId, quint64 newPosition)
{
    Action* action = getAction(cueName, deviceId);
    if(action == NULL) {
        addActionToCue(cueName, pattern, deviceId, newPosition);
        return;
    }
    action->setPatternName(pattern);
    action->setDeviceId(deviceId);
    quint64 position = newPosition / 10;
    action->setStartTime(position * 10);
}

void CueManager::cueNameChangeRequest(const QUuid &id, const QString &name)
{
    if(auto * cue = cueById(id); cue != nullptr) {
        cue->setName(name);
    }
}

Cue *CueManager::cueById(const QUuid &id) const
{
    for(auto * cue : m_cues->toList()) {
        if(id == cue->uuid()) {
            return cue;
        }
    }

    return nullptr;
}

CueSortingModel *CueManager::cuesSorted() const
{
    return m_cuesSorted;
}

void CueManager::onPlaybackTimeChanged(quint64 time)
{
    quint64 t = time / 10;
    for(const auto & c : m_cues->toList()) {
        for(const Action * a : c->actions()->toList()) {
            if(a->startTime() == t * 10) {
                emit runPattern(a->deviceId(), playerPosition(), a->patternName());
            }
        }
    }
    emit DMXWorker::instance()->playbackTimeChanged(t * 10);
}
