#pragma once

#include <QtCore/QObject>

#include <QSuperMacros.h>
#include "QQmlObjectListModel.h"

#include "CueContent.h"

class CueContentManager : public QObject
{
    Q_OBJECT
    QML_OBJMODEL_PROPERTY(CueContent, cueContentItems) //Модель всех элементов СueContent
public:
    explicit CueContentManager(QObject *parent = nullptr);
    
    void createCueContentItems(const QString& cueName, const QString& deviceId, const QString& actionID);
};
