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

void CueManager::deleteCues(QStringList deletedCueNames)
{
    for(auto &name: deletedCueNames) {
        Cue *cue = getCue(name);
        if(cue == NULL) {
            continue;
        }
        m_cues->remove(cue);
    }
}

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

Action *CueManager::getAction(const QString& cueName, int deviceId)
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
    auto * newCue = new Cue(this);
    newCue->setName(name);
    m_cues->append(newCue);
}

void CueManager::addActionToCue(const QString&  cueName, const QString&  pattern, int deviceId, quint64 newPosition)
{
    auto* cue = getCue(cueName);
    if(cue == nullptr) {
        return;
    }
    auto actions = cue->actions();
    auto* newAction = new Action(this);
    newAction->setPatternName(pattern);
    newAction->setDeviceId(deviceId);
    quint64 position = newPosition / 10;
    newAction->setStartTime(position * 10);
    actions->append(newAction);

    m_cueContentManager.createCueContentItems(cueName, QString::number(deviceId), pattern);
}

void CueManager::setActionProperty(const QString& cueName, const QString& pattern, int deviceId, quint64 newPosition)
{
    auto* action = getAction(cueName, deviceId);
    if(action == nullptr) {
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
