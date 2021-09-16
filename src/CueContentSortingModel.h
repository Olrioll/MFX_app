#pragma once

#include <QtCore/QObject>
#include <QtCore/QSortFilterProxyModel>

#include "QQmlObjectListModel.h"

#include "CueContent.h"

class CueContentSortingModel : public QSortFilterProxyModel {
    Q_OBJECT
public:
    using CueContentSourceModel = QQmlObjectListModel<CueContent>;
    explicit CueContentSortingModel(CueContentSourceModel& cues, QObject* parent = nullptr);
    void initConnections();
    static void qmlRegister();

protected:
    bool lessThan(const QModelIndex& left, const QModelIndex& right) const override;

private:
    CueContentSourceModel& m_cueContent;
};
