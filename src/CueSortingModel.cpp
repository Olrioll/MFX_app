#include "CueSortingModel.h"

#include <QtQml/QQmlEngine>

namespace  {
static constexpr char sortingRole[] = "startTime";
}

CueSortingModel::CueSortingModel(CueSourceModel &cues, QObject* parent)
    : QSortFilterProxyModel(parent)
    , m_cues(cues)
{
    setSourceModel(&m_cues);
    setSortRole(m_cues.roleForName(QByteArray(::sortingRole)));

    initConnections();
}

void CueSortingModel::initConnections()
{
    connect(&m_cues, &QQmlObjectListModelBase::dataChanged, [=](const QModelIndex &topLeft, const QModelIndex &bottomRight, const QVector<int> &roles){
        Q_UNUSED(topLeft)
        Q_UNUSED(bottomRight)

        if(roles.contains(sortRole())) {
            this->sort(0, Qt::AscendingOrder);
        }
    });
    connect(&m_cues, &QQmlObjectListModelBase::countChanged, [=](){
        this->sort(0, Qt::AscendingOrder);
    });
}

void CueSortingModel::qmlRegister()
{
    qmlRegisterUncreatableType<CueSortingModel>("MFX.Models", 1, 0, "CueSortingModel", "CueSortingModel can not be created from QML");
}

bool CueSortingModel::lessThan(const QModelIndex& left, const QModelIndex& right) const
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
