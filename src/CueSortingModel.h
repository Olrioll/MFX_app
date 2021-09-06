#pragma once

#include <QtCore/QObject>
#include <QtCore/QSortFilterProxyModel>

#include "QQmlObjectListModel.h"
#include "Cue.h"

class CueSortingModel : public QSortFilterProxyModel {
    Q_OBJECT
public:
    using CueSourceModel = QQmlObjectListModel<Cue>;

    explicit CueSortingModel(CueSourceModel &cues, QObject* parent = nullptr);

    void initConnections();
    static void qmlRegister();
protected:
    bool lessThan(const QModelIndex &left, const QModelIndex &right) const override;

private:
    CueSourceModel & m_cues;
};
