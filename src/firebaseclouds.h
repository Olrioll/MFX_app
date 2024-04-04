#ifndef FIREBASECLOUDS_H
#define FIREBASECLOUDS_H

#include <QObject>
#include "firebase/app.h"
#include "firebase/storage.h"
#include "QTimer"

class FireBaseClouds: public QObject
{
    Q_OBJECT
public:
    explicit FireBaseClouds(QObject *parent = nullptr);
    ~FireBaseClouds();
    void sendToClouds(const QByteArray &text, const QString &l, const QString &p, const QString &name = "mfxtext");

private:
    firebase::Future<firebase::storage::Metadata> future;
    QByteArray b;
    QTimer *timer = nullptr;
    firebase::storage::Storage* storage = nullptr;
    firebase::App *app = nullptr;

};

#endif // FIREBASECLOUDS_H
