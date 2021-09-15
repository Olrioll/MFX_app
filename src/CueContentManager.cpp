#include "CueContentManager.h"
#include "SequenceDevice.h"
#include "CueManager.h"

CueContentManager::CueContentManager(DeviceManager& deviceManager, QObject* parent)
    : QObject(parent)
    , m_deviceManager(deviceManager)
{
    m_cueContentItems = new QQmlObjectListModel<CueContent>(this);

    initConnections();
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

void CueContentManager::setActive(QString cueName, int deviceId, bool active)
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

void CueContentManager::qmlRegister()
{
    CueContentSelectedTableRole::registerToQml("MFX.Enums", 1, 0, "CueContentSelectedTableRole", "");
    CalculatorOperator::registerToQml("MFX.Enums", 1, 0, "CalculatorOperator", "");
    TimeUnit::registerToQml("MFX.Enums", 1, 0, "TimeUnit", "");
}

void CueContentManager::initConnections()
{
    connect(this, &CueContentManager::currentCueChanged, this, &CueContentManager::refrestCueContentModel);
}

void CueContentManager::refrestCueContentModel()
{
    m_cueContentItems->clear();

    if (m_currentCue == nullptr) {
        return;
    }

    for (auto* action : m_currentCue->actions()->toList()) {
        qInfo() << "CueContentManager::refrestCueContentModel:" << action->deviceId() << action->patternName();
        auto* cueContent = new CueContent(this);

        if(auto * device = reinterpret_cast<SequenceDevice*>(m_deviceManager.deviceById(action->deviceId())); device != nullptr) {
            cueContent->setDevice(device->id());
            cueContent->setDmxSlot(device->dmx());
            cueContent->setRfChannel(device->rfChannel());
        }

        m_cueContentItems->append(cueContent);
    }
}

void CueContentManager::updateCueContentDelay(CalculatorOperator::Type calculatorOperator, int value)
{
    qDebug() << "CueContentManager::updateCueContentDelay:" << calculatorOperator << value;
}

void CueContentManager::updateCueContentBetween(CalculatorOperator::Type calculatorOperator, int value)
{
    qDebug() << "CueContentManager::updateCueContentBetween:" << calculatorOperator << value;
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
