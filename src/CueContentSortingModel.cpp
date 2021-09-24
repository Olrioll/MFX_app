#include "CueContentSortingModel.h"

#include <QtQml/QQmlEngine>

CueContentSortingModel::CueContentSortingModel(CueContentSourceModel &cueContent, QObject* parent)
    : QSortFilterProxyModel(parent)
    , m_cueContent(cueContent)
{
    setSourceModel(&m_cueContent);
    setSortRole(m_cueContent.roleForName(CueContentSelectedTableRole::toString(CueContentSelectedTableRole::Delay).toStdString().data()));
    setSortOrder(Qt::AscendingOrder);

    initConnections();
}

void CueContentSortingModel::initConnections()
{
    connect(&m_cueContent, &QQmlObjectListModelBase::dataChanged, [=](const QModelIndex &topLeft, const QModelIndex &bottomRight, const QVector<int> &roles){
        Q_UNUSED(topLeft)
        Q_UNUSED(bottomRight)

        if(roles.contains(sortRole())) {
            this->sort(0, sortOrder());
        }
    });
    connect(&m_cueContent, &QQmlObjectListModelBase::countChanged, [=](){
        this->sort(0, sortOrder());
    });

    connect(this, &CueContentSortingModel::sortByChanged, [=](const CueContentSelectedTableRole::Type & role) {
        this->sort(0, sortOrder());
    });

    connect(this, &CueContentSortingModel::sortOrderChanged, [=](Qt::SortOrder) {
        this->sort(0, sortOrder());
    });
}

void CueContentSortingModel::setSortingPreference(const CueContentSelectedTableRole::Type& role)
{
    switch (role) {
    case CueContentSelectedTableRole::Delay:
    case CueContentSelectedTableRole::Between:
    case CueContentSelectedTableRole::Time:
    case CueContentSelectedTableRole::Prefire:
        setSortByValueType(SortByValueType::Time);
        break;
    case CueContentSelectedTableRole::Unknown:
        setSortByValueType(SortByValueType::Unknown);
        break;
    case CueContentSelectedTableRole::Action:
    case CueContentSelectedTableRole::Effect:
        setSortByValueType(SortByValueType::String);
        break;
    case CueContentSelectedTableRole::Angle:
    case CueContentSelectedTableRole::Device:
    case CueContentSelectedTableRole::DmxChannel:
    case CueContentSelectedTableRole::RfChannel:
        setSortByValueType(SortByValueType::Numeric);
        break;
    }

    //NOTE super dirty hack because Idk qt metaprogramming ;)
    setSortRole(m_cueContent.roleForName(CueContentSelectedTableRole::toString(role).toLower().toStdString().data()));
    setSortBy(role);
}

void CueContentSortingModel::qmlRegister()
{
    qmlRegisterUncreatableType<CueContentSortingModel>("MFX.Models", 1, 0, "CueContentSortingModel", "CueContentSortingModel can not be created from QML");
}

bool CueContentSortingModel::lessThan(const QModelIndex& left, const QModelIndex& right) const
{

    if(!left.isValid()) {
        return false;
    }

    if(!right.isValid()) {
        return false;
    }

    auto leftCue = sourceModel()->data(left, sortRole());
    auto rightCue = sourceModel()->data(right, sortRole());

    if(sortByValueType() == SortByValueType::Time) {
        return leftCue.toULongLong() < rightCue.toULongLong();
    } else if(sortByValueType() == SortByValueType::Numeric) {
        return leftCue.toInt() < rightCue.toInt();
    } else if(sortByValueType() == SortByValueType::String) {
        return leftCue.toString().compare(rightCue.toString(), Qt::CaseInsensitive) < 0;
    } else if(sortByValueType() == SortByValueType::Unknown) {
        return QSortFilterProxyModel::lessThan(left, right);
    }

    return QSortFilterProxyModel::lessThan(left, right);
}
