#ifndef PATTERNMODEL_H
#define PATTERNMODEL_H

#include <QAbstractListModel>

class PatternModel : public QAbstractListModel
{
    Q_OBJECT
public:
    explicit PatternModel(QObject *parent = nullptr);
    enum PatternRoles {
        NameRole = Qt::UserRole + 1,
        PrefireRole,
        DurationRole
    };
    Q_INVOKABLE void reload();
    QVariant data(const QModelIndex &index, int role = NameRole) const;
    int rowCount(const QModelIndex &parent) const;
    QHash<int, QByteArray> roleNames() const;
signals:
    void dataReady();
private:
    QList<QVariantMap> _patterns;
};

#endif // PATTERNMODEL_H
