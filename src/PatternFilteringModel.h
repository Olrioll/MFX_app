#pragma once

#include <QtCore/QObject>
#include <QtCore/QSortFilterProxyModel>

#include <QSuperMacros.h>
#include <QQmlConstRefPropertyHelpers.h>
#include "QQmlObjectListModel.h"

#include "Pattern.h"

class PatternFilteringModel : public QSortFilterProxyModel {
    Q_OBJECT
    QSM_READONLY_CSTREF_PROPERTY_WDEFAULT(PatternType::Type, filteringType, FilteringType, PatternType::Sequences)
public:
    using PatternSourceModel = QQmlObjectListModel<Pattern>;

    explicit PatternFilteringModel(PatternSourceModel & patterns, PatternType::Type type, QObject* parent = nullptr);

    Q_INVOKABLE void patternFilteringTypeChangeRequest(const PatternType::Type& filteringType);

    void initConnections();
    static void qmlRegister();

protected:
    bool filterAcceptsRow(int sourceRow, const QModelIndex& sourceParent) const override;

private:
    PatternSourceModel& m_patterns;
};
