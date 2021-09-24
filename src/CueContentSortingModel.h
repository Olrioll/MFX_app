#pragma once

#include <QtCore/QObject>
#include <QtCore/QSortFilterProxyModel>

#include <QSuperMacros.h>
#include <QQmlConstRefPropertyHelpers.h>
#include "QQmlObjectListModel.h"

#include "CueContent.h"
#include "CueContentManager.h"

class CueContentSortingModel : public QSortFilterProxyModel {
    Q_OBJECT
public:
    enum class SortByValueType : int {
        Unknown = -1,
        Numeric = 0,
        String,
        Time
    };
    Q_ENUM(SortByValueType)

private:
    QSM_READONLY_CSTREF_PROPERTY_WDEFAULT(CueContentSelectedTableRole::Type, sortBy, SortBy, CueContentSelectedTableRole::Unknown) //Роль, по которой нужно сортировать (TODO - по идее лучше сделать, чтобы она получалась из QMetaObject от CueContent)
    QSM_READONLY_CSTREF_PROPERTY_WDEFAULT(SortByValueType, sortByValueType, SortByValueType, SortByValueType::Unknown) //Тип значения - определяет применяемый тип сортировки

public:
    using CueContentSourceModel = QQmlObjectListModel<CueContent>;

    explicit CueContentSortingModel(CueContentSourceModel& cues, QObject* parent = nullptr);

    void setSortingPreference(const CueContentSelectedTableRole::Type& role);

    void initConnections();

    static void qmlRegister();
protected:
    bool lessThan(const QModelIndex& left, const QModelIndex& right) const override;

private:
    CueContentSourceModel& m_cueContent;
};
