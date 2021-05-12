#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QTranslator>

#include "SettingsManager.h"
#include "ProjectManager.h"
#include "AudioTrackRepresentation.h"
#include "WaveformWidget.h"

int main(int argc, char** argv)
{
    QApplication app(argc, argv);

    SettingsManager settings;
    ProjectManager project;

    QTranslator translator;
    translator.load(settings.value("workDirectory").toString() + "/translations/russian.qm");
    qApp->installTranslator(&translator);

    qmlRegisterType<WaveformWidget>("WaveformWidget", 1, 0, "WaveformWidget");

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("settings", &settings);
    engine.rootContext()->setContextProperty("project", &project);
    engine.rootContext()->setContextProperty("applicationDirPath", QGuiApplication::applicationDirPath());
    engine.load(QUrl(QStringLiteral("qrc:/src/qml/main.qml")));
    return app.exec();
}
