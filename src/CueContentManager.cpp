#include "CueContentManager.h"

CueContentManager::CueContentManager(QObject *parent) : QObject(parent)
{
    m_cueContentItems = new QQmlObjectListModel<CueContent>(this);
}

void CueContentManager::createCueContentItems(const QString &cueName, const QString &deviceId, const QString &actionID)
{
    auto * cueContent = new CueContent(this);
    cueContent->setDevice(deviceId);
    cueContent->setAction(actionID);

    m_cueContentItems->append(cueContent);
}
