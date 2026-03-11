#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QQmlContext>
#include <QFontDatabase>
#include "VehicleState.h"
#include "ThemeService.h"
#include "LocationService.h"
#include "MediaService.h"
#include "SettingsService.h"
#include "UnitsService.h"
#include "ConnectivityService.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQuickStyle::setStyle("Basic");

    // Load fonts and register names into ThemeService
    ThemeService themeService;
    VehicleState vehicleState;
    LocationService locationService;
    MediaService mediaService;
    SettingsService settingsService;
    UnitsService unitsService;
    ConnectivityService connectivityService;
    unitsService.setDependencies(&vehicleState, &locationService, &settingsService);

    auto loadFont = [](const QString& path) -> QString {
        int id = QFontDatabase::addApplicationFont(path);
        if (id != -1)
            return QFontDatabase::applicationFontFamilies(id).at(0);
        return QString();
    };

    const QString base = ":/qt/qml/HMItestUI/resources/fonts/";
    themeService.setFontQuicksand(loadFont(base + "Quicksand.ttf"));
    themeService.setFontOxanium(loadFont(base + "Oxanium.ttf"));
    themeService.setFontBigShoulders(loadFont(base + "BigShoulders.ttf"));
    themeService.setFontOrbitron(loadFont(base + "Orbitron.ttf"));

    // Set app default font
    if (!themeService.fontQuicksand().isEmpty())
        app.setFont(QFont(themeService.fontQuicksand(), 11));

    // Helper lambda to configure an engine
    auto setupEngine = [&](QQmlApplicationEngine& engine) {
        engine.rootContext()->setContextProperty("vehicleState", &vehicleState);
        engine.rootContext()->setContextProperty("themeService", &themeService);
        engine.rootContext()->setContextProperty("locationService", &locationService);
        engine.rootContext()->setContextProperty("mediaService", &mediaService);
        engine.rootContext()->setContextProperty("settingsService", &settingsService);
        engine.rootContext()->setContextProperty("unitsService", &unitsService);
        engine.rootContext()->setContextProperty("connectivityService", &connectivityService);
        // Wire themeBehavior changes to ThemeService
        QObject::connect(&settingsService, &SettingsService::themeBehaviorChanged,
            [&themeService, &settingsService, &locationService]() {
                const QString behavior = settingsService.themeBehavior();
                if (behavior == "dark")       themeService.setDarkMode(true);
                else if (behavior == "light") themeService.setDarkMode(false);
                // "auto" is handled by sunrise/sunset — LocationService will drive it later
            });

        // Wire sunrise/sunset to ThemeService when behavior is "auto"
        QObject::connect(&locationService, &LocationService::sunriseTimeChanged,
            [&themeService, &settingsService]() {
                if (settingsService.themeBehavior() == "auto") {
                    // placeholder — real time comparison comes with LocationService backend
                }
            });

        QObject::connect(
            &engine,
            &QQmlApplicationEngine::objectCreationFailed,
            &app,
            []() { QCoreApplication::exit(-1); },
            Qt::QueuedConnection);
    };

    QQmlApplicationEngine gaugeClusterEngine;
    setupEngine(gaugeClusterEngine);
    gaugeClusterEngine.loadFromModule("HMItestUI", "ClusterView");

    QQmlApplicationEngine infotainmentEngine;
    setupEngine(infotainmentEngine);
    infotainmentEngine.loadFromModule("HMItestUI", "InfotainmentView");

    QQmlApplicationEngine devPanelEngine;
    setupEngine(devPanelEngine);
    devPanelEngine.loadFromModule("HMItestUI", "DevPanel");

    return app.exec();
}