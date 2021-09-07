#pragma once

#include <QtCore/QObject>
#include <QtCore/QSortFilterProxyModel>

#include <QSuperMacros.h>
#include <QQmlConstRefPropertyHelpers.h>
#include "QQmlObjectListModel.h"

#include "Pattern.h"

class PatternFilteringModel : public QSortFilterProxyModel {
    Q_OBJECT
    QSM_READONLY_CSTREF_PROPERTY_WDEFAULT(PatternType::Type, filteringRole, FilteringRole, PatternType::Unknown)
public:
    using PatternSourceModel = QQmlObjectListModel<Pattern>;

    explicit PatternFilteringModel(PatternSourceModel & patterns, QObject* parent = nullptr);

    Q_INVOKABLE void patternFilteringTypeChangeRequest(const PatternType::Type& filteringType);

    void initConnections();
    static void qmlRegister();

protected:
    bool filterAcceptsRow(int row, const QModelIndex& parent) const override;

private:
    PatternSourceModel& m_patterns;
};
