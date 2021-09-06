#include "PatternModel.h"

PatternModel::PatternModel(QObject *parent): QAbstractListModel(parent)
{
    reload();
}

void PatternModel::reload()
{
    beginResetModel();
    _patterns.clear();
    endResetModel();
    emit dataReady();
}

QVariant PatternModel::data(const QModelIndex &index, int role) const
{
    if (index.row() < 0 || index.row() > _patterns.count()) {
        return QVariant();
    }
    const QVariantMap& pattern = _patterns[index.row()];
    switch(role) {
    case NameRole:
        Q_UNUSED(pattern); // todo: extract name from pattern
        break;
    case PrefireRole:
         // todo: extract prefire from pattern
        break;
    case DurationRole:
         // todo: extract duration from pattern
        break;
    }
    return QVariant();
}

int PatternModel::rowCount(const QModelIndex &parent) const
{
    Q_UNUSED(parent)
    return _patterns.count();
}

QHash<int, QByteArray> PatternModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[NameRole] = "name";
    roles[PrefireRole] = "prefire";
    roles[DurationRole] = "duration";
    return roles;
}
