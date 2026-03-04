#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QQmlContext>
#include <QFontDatabase>
#include "VehicleState.h"
#include "ThemeService.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    QQuickStyle::setStyle("Basic");

    // Load fonts and register names into ThemeService
    ThemeService themeService;
    VehicleState vehicleState;

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

    // Set app default font
    if (!themeService.fontQuicksand().isEmpty())
        app.setFont(QFont(themeService.fontQuicksand(), 11));

    // Helper lambda to configure an engine
    auto setupEngine = [&](QQmlApplicationEngine& engine) {
        engine.rootContext()->setContextProperty("vehicleState", &vehicleState);
        engine.rootContext()->setContextProperty("themeService", &themeService);
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