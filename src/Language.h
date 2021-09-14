#pragma once

#include <QtCore/QObject>

#include "QQmlObjectListModel.h"
#include <QQmlConstRefPropertyHelpers.h>
#include <QQmlVarPropertyHelpers.h>
#include <QSuperMacros.h>

class Language : public QObject {
    Q_OBJECT
    QSM_READONLY_CSTREF_PROPERTY_WDEFAULT(QString, locale, Locale, "")
    QSM_READONLY_CSTREF_PROPERTY_WDEFAULT(QString, name, Name, "")
    QSM_READONLY_CSTREF_PROPERTY_WDEFAULT(QString, icon, Icon, "")

    //Интерфейс
    QSM_READONLY_VAR_PROPERTY_WDEFAULT(bool, selected, Selected, false)

public:
    explicit Language(QObject* parent = nullptr);
};
