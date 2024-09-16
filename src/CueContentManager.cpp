#include "CueContentManager.h"

#include <QtCore/QtMath>

#include "SequenceDevice.h"
#include "CueManager.h"
#include "CueContentSortingModel.h"

namespace  {
static constexpr char actionStartTimeChangeRole[] = "startTime";
}

CueContentManager::CueContentManager(DeviceManager& deviceManager, QObject* parent)
    : QObject(parent)
    , m_deviceManager(deviceManager)
{
    m_cueContentItems = new QQmlObjectListModel<CueContent>(this);
    m_cueContentSorted = new CueContentSortingModel(*m_cueContentItems, this);
    m_cueContentSorted->setSortBy(CueContentSelectedTableRole::Delay);

    initConnections();
}


void CueContentManager::initConnections()
{
    connect(this, &CueContentManager::currentCueChanged, this, &CueContentManager::refrestCueContentModel);

}

void CueContentManager::changeCurrentCue(Cue * cue)
{
    if(m_currentCue != nullptr) {
        disconnect(m_currentCue->actions(), &QQmlObjectListModelBase::dataChanged, this, &CueContentManager::onCurrentCueActionsChanged);
    }

    setCurrentCue(cue);

    if(m_currentCue != nullptr) {
        connect(m_currentCue->actions(), &QQmlObjectListModelBase::dataChanged, this, &CueContentManager::onCurrentCueActionsChanged);
    }
}

void CueContentManager::onUpdateCueContentValueRequest(CueContentSelectedTableRole::Type selectedRole, CalculatorOperator::Type calculatorOperator, int value, TimeUnit::Type timeUnit)
{
    quint64 msecValue = value;
    switch(selectedRole) {
    case CueContentSelectedTableRole::Delay:
    case CueContentSelectedTableRole::Between:
        switch(timeUnit) {
        case TimeUnit::Minutes:
            msecValue *=60;
        case TimeUnit::Seconds:
            msecValue *= 1000;
            break;
        default:
            break;
        }
    default:
        break;
    }
    switch (selectedRole) {
    case CueContentSelectedTableRole::Delay:
        return updateCueContentDelay(calculatorOperator, msecValue);
    case CueContentSelectedTableRole::Between:
        return updateCueContentBetween(calculatorOperator, msecValue);
    case CueContentSelectedTableRole::Action:
        return updateCueContentAction(calculatorOperator, value);
    default:
        break;
    }
}

void CueContentManager::onTimingTypeSelectedTableRoleChangeRequest(const CueContentSelectedTableRole::Type &role)
{
    setTimingTypeSelectedTableRole(role);
}

void CueContentManager::onDeviceTypeSelectedTableRoleChangeRequest(const CueContentSelectedTableRole::Type &role)
{
    setDeviceTypeSelectedTableRole(role);
}

void CueContentManager::onActionTypeSelectedTableRoleChangeRequest(const CueContentSelectedTableRole::Type &role)
{
    setActionTypeSelectedTableRole(role);
}

void CueContentManager::onDurationTypeSelectedTableRoleChangeRequest(const CueContentSelectedTableRole::Type &role)
{
    setDurationTypeSelectedTableRole(role);
}

QList<int> CueContentManager::onGetSelectedDeviseList()
{
    QList<int> selectedList;
    for(auto * cueContentItem : m_cueContentItems->toList()){
        if( cueContentItem->selected())
        {
            selectedList << cueContentItem->device();
        }
    }

    return selectedList;
}

void CueContentManager::onMirror()
{
    QList<CueContent*> l;
    for(auto * cueContentItem : m_cueContentItems->toList()){
        if( cueContentItem->selected())
        {

            l << cueContentItem;
        }
    }

    for(auto i = 0,y = l.size() -1; i < l.size(); i++,--y){
        if(i<y){
         auto dev = l[i]->device();
         auto act = l[i]->action();
         l[i]->setDevice(l[y]->device());
         l[i]->setAction(l[y]->action());
         l[y]->setDevice(dev);
         l[y]->setAction(act);
        }else return;
    }
}

void CueContentManager::onSelectedChangeAction(const QString &name)
{
    for(auto * cueContentItem : m_cueContentItems->toList()){
        if( cueContentItem->selected())
        {

            cueContentItem->setAction(name);
        }
    }
}

void CueContentManager::onSelectItemRequest(const QUuid& id)
{
    if(auto * cueContent = cueContentById(id); cueContent != nullptr) {
        cueContent->setSelected(true);
    } else {
        qWarning() << "Item with requested id" << id << "doesn not exist";
    }
}

void CueContentManager::onDeselectItemRequest(const QUuid &id)
{
    if(auto * cueContent = cueContentById(id); cueContent != nullptr) {
        cueContent->setSelected(false);
    } else {
        qWarning() << "Item with requested id" << id << "doesn not exist";
    }
}

void CueContentManager::onSelectAllItemsRequest()
{
    bool selection = false;
    for(auto * cueContentItem : m_cueContentItems->toList()){
        if( cueContentItem->selected())
            continue;
        else {
            selection = true;
            break;
        }
    }

    for(auto * cueContentItem : m_cueContentItems->toList()) {
        cueContentItem->setSelected(selection);

    }
}

void CueContentManager::onDeselecAllItemsRequest()
{
    for(auto * cueContentItem : m_cueContentItems->toList()) {
        cueContentItem->setSelected(false);
    }
}

void CueContentManager::onSelectEvenItemsRequest()
{
    for(auto * cueContentItem : m_cueContentItems->toList()) {
        const int index = m_cueContentItems->indexOf(cueContentItem);

        cueContentItem->setSelected((index % 2) != 0);
    }
}

void CueContentManager::onSelectUnevenItemsRequest()
{
    for(auto * cueContentItem : m_cueContentItems->toList()) {
        const int index = m_cueContentItems->indexOf(cueContentItem);

        cueContentItem->setSelected((index % 2) == 0);
    }
}

void CueContentManager::onSelectLeftItemsRequest()
{
    for(auto * cueContentItem : m_cueContentItems->toList()) {
        const int index = m_cueContentItems->indexOf(cueContentItem);

        cueContentItem->setSelected(index < std::floor(m_cueContentItems->count() / 2));
    }
}

void CueContentManager::onSelectRightItemsRequest()
{
    for(auto * cueContentItem : m_cueContentItems->toList()) {
        const int index = m_cueContentItems->indexOf(cueContentItem);

        cueContentItem->setSelected(index >= std::ceil(m_cueContentItems->count() / 2));
    }
}

void CueContentManager::cleanSelectionRequest()
{
    qInfo() << "Clean Selection request";

    setSelectedTableRole(CueContentSelectedTableRole::Unknown);

    for(auto * cueContentItem : m_cueContentItems->toList()) {
        cueContentItem->setSelected(false);
    }
}

void CueContentManager::onSelectAllFromHeaderRequest(const CueContentSelectedTableRole::Type &role)
{
    qInfo() << "Select all from header request";

    setSelectedTableRole(role);

    for(auto * cueContentItem : m_cueContentItems->toList()) {
        cueContentItem->setSelected(true);
    }
}

void CueContentManager::onDeselectAllFromHeaderRequest(const CueContentSelectedTableRole::Type &role)
{
    qInfo() << "Deselect all from header request";

    setSelectedTableRole(role);

    for(auto * cueContentItem : m_cueContentItems->toList()) {
        cueContentItem->setSelected(false);
    }
}

void CueContentManager::onSortFromHeaderRequest(const CueContentSelectedTableRole::Type& role, const CueContentSortingType::Type& sortOrder)
{
    qInfo() << "Sort by" << role << "requested";

    //NOTE Сортировка только визуальная - она не должна изменять данные
    m_cueContentSorted->setSortingPreference(role, sortOrder);
}

CueContent *CueContentManager::cueContentById(const QUuid& id) const
{
    for(auto * cueContentItem : m_cueContentItems->toList()) {
        if(cueContentItem->uuid() == id) {
            return cueContentItem;
        }
    }

    return nullptr;
}

void CueContentManager::setActive(const QString& cueName, int deviceId, bool active)
{
    if(currentCue() == NULL) {
        return;
    }
    if(currentCue()->name() != cueName) {
        return;
    }
    for (auto cueContentItem : m_cueContentItems->toList()) {
        if(deviceId == cueContentItem->device()) {
            cueContentItem->setActive(active);
        }
    }
}

void CueContentManager::setAllUnActive()
{
    for (auto cueContentItem : m_cueContentItems->toList()) {
            cueContentItem->setActive(false);
    }
}

CueContentSortingModel *CueContentManager::cueContentSorted() const
{
    return m_cueContentSorted;
}

void CueContentManager::qmlRegister()
{
    CueContentSortingType::registerToQml("MFX.Enums", 1, 0);
    CueContentSelectedTableRole::registerToQml("MFX.Enums", 1, 0);
    CalculatorOperator::registerToQml("MFX.Enums", 1, 0);
    TimeUnit::registerToQml("MFX.Enums", 1, 0);

}

void CueContentManager::onCurrentCueActionsChanged(const QModelIndex &topLeft, const QModelIndex &bottomRight, const QVector<int> &roles)
{
    if(roles.contains(currentCue()->actions()->roleForName(actionStartTimeChangeRole))) {
        //TODO - вот эта вот штука по идее очень неправильна - метод должен триггерить изменения только cueContent айтемов, а sortfilterproxymodel всё сама разрулит
        refrestCueContentModel();
    }
}

void CueContentManager::refrestCueContentModel()
{
    m_cueContentItems->clear();

    if (m_currentCue == nullptr) {
        return;
    }

    quint64 prevStop = m_currentCue->startTime();
    auto listActions = m_currentCue->actions()->toList();
    std::sort(listActions.begin(), listActions.end(), [](Action* a1, Action *a2) {
        return a1->startTime() < a2->startTime();
    });

    for (auto* action : listActions) {
        auto* cueContent = new CueContent(this);
        cueContent->setDelay(action->startTime() - m_currentCue->startTime());
        //qDebug() << tr("CueContentManager::refreshCueContentModel, delay = %1").arg(cueContent->delay());
        cueContent->setBetween(action->startTime() - prevStop);
        auto pattern = m_deviceManager.m_patternManager->patternByName(action->patternName());
        prevStop = action->startTime() + pattern->duration();
        //qDebug() << tr("CueContentManager::refreshCueContentModel, between = %1").arg(cueContent->between());
        cueContent->setTime(action->startTime() + pattern->prefireDuration());
        //qDebug() << tr("CueContentManager::refreshCueContentModel, time = %1").arg(cueContent->time());
        cueContent->setPrefire(pattern->prefireDuration());
        //qDebug() << tr("CueContentManager::refreshCueContentModel, prefire = %1").arg(cueContent->prefire());

        if(auto * device = reinterpret_cast<SequenceDevice*>(m_deviceManager.deviceById(action->deviceId())); device != nullptr) {
            cueContent->setDevice(device->id());
            cueContent->setDmxSlot(device->dmx());
            cueContent->setRfChannel(device->rfChannel());
        }

        cueContent->setAction(action->patternName());

        m_cueContentItems->append(cueContent);
    }
}

void CueContentManager::updateCueContentDelay(CalculatorOperator::Type calculatorOperator, quint64 value)
{
    qDebug() << "CueContentManager::updateCueContentDelay:" << calculatorOperator << value;
    for (auto cueContentItem : m_cueContentItems->toList()) {
        if(cueContentItem->selected()) {
            quint64 delay = cueContentItem->delay();
            switch (calculatorOperator) {
            case CalculatorOperator::Add:
                delay += value;
                break;
            case CalculatorOperator::Substract:
                delay -= value;
                break;
            case CalculatorOperator::Multiply:
                delay *= value;
                break;
            case CalculatorOperator::Divide:
                delay /= value;
                break;
            case CalculatorOperator::Percent:
                delay = value / delay * 100;
                break;
            }
            if(m_currentCue == NULL) {
                continue;
            }
            auto a = m_cueManager->getAction(m_currentCue->name(), cueContentItem->device());
            if(a == NULL) {
                continue;
            }
            a->setStartTime(m_currentCue->startTime() + delay);
        }
    }
}

void CueContentManager::updateCueContentBetween(CalculatorOperator::Type calculatorOperator, quint64 value)
{
    qDebug() << "CueContentManager::updateCueContentBetween:" << calculatorOperator << value;
    for (auto cueContentItem : m_cueContentItems->toList()) {
        if(cueContentItem->selected()) {
            quint64 between = cueContentItem->between();
            switch (calculatorOperator) {
            case CalculatorOperator::Add:
                between += value;
                break;
            case CalculatorOperator::Substract:
                between -= value;
                break;
            case CalculatorOperator::Multiply:
                between *= value;
                break;
            case CalculatorOperator::Divide:
                between /= value;
                break;
            case CalculatorOperator::Percent:
                between = value / between * 100;
                break;
            }
            if(m_currentCue == NULL) {
                continue;
            }
            auto a = m_cueManager->getAction(m_currentCue->name(), cueContentItem->device());
            if(a == NULL) {
                continue;
            }
            //a->set
        }
    }
}

void CueContentManager::updateCueContentAction(CalculatorOperator::Type calculatorOperator, int value)
{
    qDebug() << "CueContentManager::updateCueContentAction:" << calculatorOperator << value;
    for (auto cueContentItem : m_cueContentItems->toList()) {
        if(cueContentItem->selected()) {
            QString actionStr = cueContentItem->action();
            actionStr.remove(0, 1); // delete "A" from the beginning of the string
            int action = actionStr.toInt();
            switch (calculatorOperator) {
            case CalculatorOperator::Add:
                action += value;
                break;
            case CalculatorOperator::Substract:
                action -= value;
                break;
            case CalculatorOperator::Multiply:
                action *= value;
                break;
            case CalculatorOperator::Divide:
                action /= value;
                break;
            case CalculatorOperator::Percent:
                action = value / action * 100;
                break;
            }
            actionStr = QString("A%1").arg(action);
            if(m_currentCue == NULL) {
                continue;
            }
            auto a = m_cueManager->getAction(m_currentCue->name(), cueContentItem->device());
            if(a == NULL) {
                continue;
            }
            a->setPatternName(actionStr);
        }
    }
}
