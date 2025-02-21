#include "CueContentSortingModel.h"

#include <QtQml/QQmlEngine>

namespace  {
static constexpr char sortingRole[] = "delay";
}

CueContentSortingModel::CueContentSortingModel(CueContentSourceModel &cueContent, QObject* parent)
    : QSortFilterProxyModel(parent)
    , m_cueContent(cueContent)
{
    setSourceModel(&m_cueContent);
    setSortRole(m_cueContent.roleForName(QByteArray(::sortingRole)));

    initConnections();
}

void CueContentSortingModel::initConnections()
{
    connect(&m_cueContent, &QQmlObjectListModelBase::dataChanged, [=](const QModelIndex &topLeft, const QModelIndex &bottomRight, const QVector<int> &roles){
        Q_UNUSED(topLeft)
        Q_UNUSED(bottomRight)

        if(roles.contains(sortRole())) {
            this->sort(0, Qt::AscendingOrder);
        }
    });
    connect(&m_cueContent, &QQmlObjectListModelBase::countChanged, [=](){
        this->sort(0, Qt::AscendingOrder);
    });
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

    return leftCue.toULongLong() < rightCue.toULongLong();
}
