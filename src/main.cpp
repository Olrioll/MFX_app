#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QTranslator>
#include <QSharedPointer>

#include "SettingsManager.h"
#include "ProjectManager.h"
#include "ActionsManager.h"
#include "AudioTrackRepresentation.h"
#include "WaveformWidget.h"
#include "cursormanager.h"

int main(int argc, char** argv)
{
    QApplication app(argc, argv);
    app.setOrganizationName("MFX");
    app.setOrganizationDomain("mfx.com");

    SettingsManager settings;
    ProjectManager project(settings);
    ActionsManager actionsManager(settings);
    actionsManager.loadActions();
    CursorManager cursorManager;

    QTranslator translator;
    translator.load(settings.value("workDirectory").toString() + "/translations/russian.qm");
    qApp->installTranslator(&translator);

    qmlRegisterType<WaveformWidget>("WaveformWidget", 1, 0, "WaveformWidget");

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("settingsManager", &settings);
    engine.rootContext()->setContextProperty("project", &project);
    engine.rootContext()->setContextProperty("actionsManager", &actionsManager);
    engine.rootContext()->setContextProperty("cursorManager", &cursorManager);
    engine.rootContext()->setContextProperty("applicationDirPath", QGuiApplication::applicationDirPath());
    engine.load(QUrl(QStringLiteral("qrc:/src/qml/main.qml")));
    return app.exec();
}
