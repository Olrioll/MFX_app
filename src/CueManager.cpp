#include "CueManager.h"

CueManager::CueManager(QObject *parent) : QObject(parent)
{
    connect(this, &CueManager::playerPositionChanged, this, &CueManager::onPlaybackTimeChanged);
    m_cues = new QQmlObjectListModel<Cue>(this);
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

Action *CueManager::getAction(QString cueName, int actId)
{
    Action *act = NULL;
    Cue* cue = getCue(cueName);
    if(cue == NULL) {
        return NULL;
    }
    for(const auto & a : cue->get_actions()->toList()) {
        if(a->id() == actId) {
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
    newCue->setName(name);
    m_cues->append(newCue);
}

void CueManager::addActionToCue(QString cueName, QString pattern, int patchId, quint64 newPosition)
{
    Q_UNUSED(patchId)
    Cue* cue = getCue(cueName);
    if(cue == NULL) {
        return;
    }
    auto actions = cue->getActionsModel();
    Action* newAction = new Action(this);
    //newAction->setPatternName(pattern);
    newAction->setId(patchId);
    newAction->setstartTime(newPosition);
    actions->append(newAction);
}

void CueManager::setActionProperty(QString cueName, QString pattern, int patchId, quint64 newPosition)
{
    Action* action = getAction(cueName, patchId);
    if(action == NULL) {
        addActionToCue(cueName, pattern, patchId, newPosition);
        return;
    }
    //action->setPatternName(pattern);
    action->setId(patchId);
    action->setstartTime(newPosition);
}

void CueManager::onPlaybackTimeChanged(quint64 time)
{
    for(const auto & c : m_cues->toList()) {
        for(const Action * a : c->getActionsModel()->toList()) {
            if(a->startTime() == time) {
                qDebug() << "fire!" << time << c->name() << a->id() /*<< a->patternName()*/;
            }
        }
    }
}

