#include "PatternFilteringModel.h"

namespace  {
static constexpr char filterRole[] = "type";
}

PatternFilteringModel::PatternFilteringModel(PatternSourceModel& patterns, QObject* parent)
    : QSortFilterProxyModel(parent)
    , m_patterns(patterns)
{
    setSourceModel(&m_patterns);
    setFilterRole(m_patterns.roleForName(QByteArray(::filterRole)));
    initConnections();
}

void PatternFilteringModel::patternFilteringTypeChangeRequest(const PatternType::Type& filteringType)
{
    setFilteringType(filteringType);
}

void PatternFilteringModel::initConnections()
{
    connect(&m_patterns, &QQmlObjectListModelBase::countChanged, [=](){
        this->invalidateFilter();
    });
    connect(this, &PatternFilteringModel::filteringTypeChanged, [=](){
        this->invalidateFilter();
    });
}

void PatternFilteringModel::qmlRegister()
{
    qmlRegisterUncreatableType<PatternFilteringModel>("MFX.Models", 1, 0, "PatternFilteringModel", "PatternFilteringModel can not be created from QML");
}

bool PatternFilteringModel::filterAcceptsRow(int sourceRow, const QModelIndex& sourceParent) const
{
    auto rowModelIndex = sourceModel()->index(sourceRow, 0, sourceParent);
    auto itemData = qvariant_cast<PatternType::Type>(sourceModel()->data(rowModelIndex, filterRole()));

    return itemData == m_filteringType;
}
