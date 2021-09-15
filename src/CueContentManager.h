#pragma once

#include <QtCore/QObject>

#include "QQmlObjectListModel.h"
#include "QQmlPtrPropertyHelpers.h"
#include <QSuperMacros.h>

#include "CueContent.h"
#include "Cue.h"
#include "DeviceManager.h"

class CueContentManager : public QObject {
    Q_OBJECT
    QML_OBJMODEL_PROPERTY(CueContent, cueContentItems) //Модель всех элементов СueContent
    QSM_READONLY_PTR_PROPERTY_WDEFAULT(Cue, currentCue, CurrentCue, nullptr) //Текущая выбранная Cue
public:
    explicit CueContentManager(DeviceManager& deviceManager, QObject* parent = nullptr);

private:
    void initConnections();
    void refrestCueContentModel();

private:
    DeviceManager& m_deviceManager;
};
