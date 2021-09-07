#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QSharedPointer>
#include <QTranslator>
#include <QQuickStyle>

#include "ProjectManager.h"
#include "SettingsManager.h"
#include "AudioTrackRepresentation.h"
#include "WaveformWidget.h"
#include "cursormanager.h"
#include "CueManager.h"
#include "CueSortingModel.h"
#include "DeviceManager.h"
#include "PatternManager.h"
#include "PatternFilteringModel.h"

int main(int argc, char** argv)
{
    QApplication app(argc, argv);
    app.setOrganizationName("MFX");
    app.setOrganizationDomain("mfx.com");

    SettingsManager settings;
    ProjectManager project(settings);
    PatternManager patternManager(settings);
    patternManager.initPatterns();
    CursorManager cursorManager;
    CueManager cueManager;
    DeviceManager deviceManager;
    QObject::connect(&cueManager, &CueManager::runPattern, &deviceManager, &DeviceManager::onRunPattern);

    QTranslator translator;
    translator.load("qrc:/translations/russian.qm");
    qApp->installTranslator(&translator);

    qmlRegisterType<WaveformWidget>("WaveformWidget", 1, 0, "WaveformWidget");

    CueSortingModel::qmlRegister();
    PatternManager::qmlRegister();
    PatternFilteringModel::qmlRegister();

    QQmlApplicationEngine engine;

    engine.addImportPath("qrc:/");

    engine.rootContext()->setContextProperty("settingsManager", &settings);
    engine.rootContext()->setContextProperty("project", &project);
    engine.rootContext()->setContextProperty("patternManager", &patternManager);
    engine.rootContext()->setContextProperty("cursorManager", &cursorManager);
    engine.rootContext()->setContextProperty("applicationDirPath", QGuiApplication::applicationDirPath());
    engine.rootContext()->setContextProperty("cueManager", &cueManager);
    engine.rootContext()->setContextProperty("deviceManager", &deviceManager);

    engine.load(QUrl(QStringLiteral("qrc:/MFX/UI/ApplicationWindow.qml")));

    return app.exec();
}
