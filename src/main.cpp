#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "AudioTrackRepresentation.h"
#include "WaveformWidget.h"

int main(int argc, char** argv)
{
    QApplication app(argc, argv);

    qmlRegisterType<WaveformWidget>("WaveformWidget", 1, 0, "WaveformWidget");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/src/qml/main.qml")));
    return app.exec();
}
