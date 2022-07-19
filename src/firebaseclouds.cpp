#include "FireBaseClouds.h"
#include <QtQml/QQmlEngine>

using firebase::App;
using firebase::AppOptions;
using firebase::storage::Storage;


FireBaseClouds::FireBaseClouds(QObject *parent):QObject(parent)
{
    auto opt = AppOptions();
    opt.set_api_key("AIzaSyC8iW8A0BY64Y07U8ukn_DDXcAQ-GicEAM");
    opt.set_app_id("1:586717828993:android:ed04b654018fde1ebd7a80");
    opt.set_project_id("mobilefireapp-b3924");
    app = App::Create(opt);
    timer = new QTimer;
    storage = Storage::GetInstance(app,"gs://mobilefireapp-b3924.appspot.com");

    connect(timer, &QTimer::timeout, [=]{
        if (future.status() != firebase::kFutureStatusPending) {
            if (future.status() != firebase::kFutureStatusComplete) {
                timer->stop();
                qDebug()<<"ERROR: GetData() returned an invalid future.";
                // Handle the error...

            } else if (future.error() != firebase::storage::kErrorNone) {
                timer->stop();
                qDebug()<<"ERROR: GetData() returned error" << future.error() <<  future.error_message();
                // Handle the error...

            }
        } else {
            timer->stop();
            qDebug()<<"All DONE!";
            // Metadata contains file metadata such as size, content-type, and download URL.
            auto metadata = future.result();
            //            std::string download_url = metadata->path();
            //            qDebug()<<"All DONE!" << metadata->path();
        }
    } );
}

FireBaseClouds::~FireBaseClouds()
{
    delete storage;
    storage = nullptr;
    delete app;
    app = nullptr;
}

void FireBaseClouds::sendToClouds(const QByteArray &text, const QString &l, const QString &p, const QString &name)
{
    if(!timer->isActive()){
        auto storage_ref = storage->GetReference();
        auto file_ref = storage_ref.Child(QStringLiteral("%1/%2/v/%3").arg(l).arg(p).arg(name).toStdString());
        b = text;
        future = file_ref.PutBytes(b.data(), b.size());
        timer->start(1000);
    }
}
