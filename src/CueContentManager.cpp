#include "CueContentManager.h"

#include "SequenceDevice.h"

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
    case CueContentSelectedTableRole::Between:
    case CueContentSelectedTableRole::Action:
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
        break;
    case CueContentSelectedTableRole::Between:
        break;
    case CueContentSelectedTableRole::Action:
        break;
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
        qInfo() << action->deviceId() << action->patternName();
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

}

void CueContentManager::updateCueContentBetween(CalculatorOperator::Type calculatorOperator, int value)
{

}

void CueContentManager::updateCueContentAction(CalculatorOperator::Type calculatorOperator, int patternNum)
{

}
