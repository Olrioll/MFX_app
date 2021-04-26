#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QTranslator>

#include "AudioTrackRepresentation.h"
#include "WaveformWidget.h"

int main(int argc, char** argv)
{
    QApplication app(argc, argv);

    QTranslator translator;
    translator.load("translations/russian.qm");
    qApp->installTranslator(&translator);

    qmlRegisterType<WaveformWidget>("WaveformWidget", 1, 0, "WaveformWidget");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/src/qml/main.qml")));
    return app.exec();
}
