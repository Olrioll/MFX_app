#include "CueManager.h"

#include <QtCore/QRandomGenerator>

#include "CueSortingModel.h"
#include "PatternManager.h"

namespace  {
static constexpr char playerExpandedRoleName[] = "expanded";
}

CueManager::CueManager(CueContentManager& cueContentManager, QObject* parent)
    : QObject(parent)
    , m_cueContentManager(cueContentManager)
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
    connect(m_cues, &QQmlObjectListModelBase::dataChanged, [=](const QModelIndex &topLeft, const QModelIndex &bottomRight, const QVector<int> &roles) {
        if(roles.contains(m_cues->roleForName(playerExpandedRoleName))) {
            auto * changedCue = m_cues->at(topLeft.row());
            emit cueExpandedChanged(changedCue->name(), changedCue->expanded());

            if(changedCue->expanded()) {
                m_cueContentManager.changeCurrentCue(changedCue);
            } else {
                m_cueContentManager.changeCurrentCue(nullptr);
            }
        }
    });

    connect(m_cues, &QQmlObjectListModelBase::rowsAboutToBeRemoved, [=](const QModelIndex &parent, int first, int last){
        for(int index = first; index <= last; index++) {
            auto * cue = m_cues->at(index);
            if((cue != nullptr) && cue->expanded()) {
                cue->setExpanded(false);
                m_cueContentManager.changeCurrentCue(nullptr);
            }
        }
    });
}

void CueManager::deleteCues(QStringList deletedCueNames)
{
    for(const auto &name: deletedCueNames) {
        auto * cue = cueByName(name);
        if(cue == nullptr) {
            qWarning() << "Cue with name" << name << "was not found";
            continue;
        }
        m_cues->remove(cue);
    }
}

Cue* CueManager::cueByName(const QString &name) const
{
    for (auto * cue : m_cues->toList()) {
        if (cue->name().compare(name) == 0) {
            return cue;
        }
    }
    return nullptr;
}

Action *CueManager::getAction(const QString& cueName, int deviceId)
{
    Action* act = NULL;
    Cue* cue = cueByName(cueName);
    if (cue == NULL) {
        return NULL;
    }

    for (const auto& a : cue->actions()->toList()) {
        if (a->deviceId() == deviceId) {
            act = a;
            break;
        }
    }
    return act;
}

void CueManager::onAddCue(QVariantMap properties)
{
    QString name = properties.value("name").toString();
    //double newYposition = properties.value("newYposition").toDouble();
    auto * newCue = new Cue(this);
    newCue->setName(name);
    m_cues->append(newCue);
}

void CueManager::onDeleteAllCue()
{
    m_cues->clear();
}

void CueManager::onRecalculateCue()
{
    for( auto * cue : m_cues->toList()){
        recalculateCueStartAndDuration(cue->name());
    }
}

void CueManager::onDeleteCue(const QString &cueName)
{
    auto * cue = cueByName(cueName);
    if(cue == nullptr) {
        qWarning() << "Cue with name" << cueName << "was not found";
    }else  m_cues->remove(cue);
}

void CueManager::addActionToCue(const QString&  cueName, const QString&  pattern, int deviceId, quint64 newPosition)
{
    Cue* cue = cueByName(cueName);
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

    recalculateCueStartAndDuration(cueName);
}

void CueManager::recalculateCueStartAndDuration(const QString &cueName)
{
    Cue* cue = cueByName( cueName );
    if( !cue )
        return;

    auto patternManager = m_deviceManager->GetPatternManager();
    quint64 cueStart = -1; // very big positive number since type is unsigned
    quint64 cueStop = 0;

    for( auto action : cue->actions()->toList() )
    {
        const Pattern* pattern = patternManager->patternByName(action->patternName());
        if( !pattern )
            continue;

        if( cueStart > action->startTime() )
            cueStart = action->startTime();

        Device* device = m_deviceManager->deviceById( action->deviceId() );
        qulonglong duration = device ? device->getDurationByPattern( *pattern ) : 0;

        if( cueStop < action->startTime() + duration )
            cueStop = action->startTime() + duration;
    }

    cue->setStartTime( cueStart );
    cue->setDurationTime( cueStop - cueStart );
}

void CueManager::onSetActionProperty(const QString& cueName, const QString& pattern, int deviceId, quint64 newPosition)
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
    recalculateCueStartAndDuration(cueName);
}

void CueManager::cueNameChangeRequest(const QUuid& id, const QString& name)
{
    if (auto* cue = cueById(id); cue != nullptr) {
        cue->setName(name);
    }
}

void CueManager::collapseCueOnPlayerRequest(const QString& name)
{
    if(auto* cue = cueByName(name))
        cue->setExpanded(false);
}

void CueManager::expandCueOnPlayerRequest(const QString &name)
{
    if(auto* cue = cueByName(name))
        cue->setExpanded(true);
}

void CueManager::cueSelectedOnCueListRequest(const QString &name)
{
    for(auto * cue : m_cues->toList())
    {
        bool selectedCue = cue->name().compare(name) == 0;
        cue->setSelected(selectedCue);
    }
}

void CueManager::cueDeselectedOnCueListRequest(const QString &name)
{
    if(auto * cue = cueByName(name))
        cue->setSelected(false);
}

Cue* CueManager::cueById(const QUuid& id) const
{
    for (auto* cue : m_cues->toList())
        if (id == cue->uuid())
            return cue;

    return nullptr;
}

CueSortingModel* CueManager::cuesSorted() const
{
    return m_cuesSorted;
}

void CueManager::onPlaybackTimeChanged(quint64 time)
{
    auto patternManager = m_deviceManager->GetPatternManager();
    quint64 t = time / 10 * 10;

    for (const auto c : m_cues->toList())
    {
        for (const Action* a : c->actions()->toList())
        {
            const auto pattern = patternManager->patternByName(a->patternName());
            if(pattern == nullptr)
                continue;

            if (a->startTime() - pattern->prefireDuration() == t)
            {
                //qDebug() << "start" << time << pattern->prefireDuration();
                emit runPatternSingly( a->deviceId(), playerPosition(), a->patternName() );
                m_cueContentManager.setActive(c->name(), a->deviceId(), true);
                c->setActive(true);
            }

            Device* device = m_deviceManager->deviceById( a->deviceId() );
            if( !device )
                continue;

            quint64 duration = device->getDurationByPattern( *pattern );

            if(c->active() && a->startTime() - pattern->prefireDuration() + duration == t)
            {
                //qDebug() << "stop" << time << duration;
                c->setActive(false);
                m_cueContentManager.setActive(c->name(), a->deviceId(), false);
            }
        }
    }

    emit DMXWorker::instance()->playbackTimeChanged(t);
}
