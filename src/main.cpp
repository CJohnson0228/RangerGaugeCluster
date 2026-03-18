#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QQmlContext>
#include <QtWebEngineQuick/QtWebEngineQuick>
#include <QQuickWebEngineProfile>
#include <QFontDatabase>
#include "VehicleState.h"
#include "ThemeService.h"
#include "LocationService.h"
#include "MediaService.h"
#include "SettingsService.h"
#include "UnitsService.h"
#include "ConnectivityService.h"
#include "WeatherService.h"
#include "ClimateService.h"
#include "SpotifyService.h"

int main(int argc, char *argv[])
{
    // Must be set before QGuiApplication so WebEngineProfile storage paths are stable
    QCoreApplication::setApplicationName("HMItest");

    // Widevine CDM for DRM content (Netflix, Hulu) — only enable on car hardware
    // where Chrome is installed. Mismatched flags on dev machine invalidate profile state.
    // qputenv("QTWEBENGINE_CHROMIUM_FLAGS",
    //     "--widevine-cdm-path=/opt/google/chrome/WidevineCdm"
    //     " --enable-features=PlatformEncryptedDolbyVision");
    QtWebEngineQuick::initialize();
    qputenv("QT_IM_MODULE", "qtvirtualkeyboard");
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
    WeatherService weatherService;
    ClimateService climateService;
    SpotifyService spotifyService;

    // Web app profiles — created in C++ so storageName is set at construction,
    // not as a QML property after the fact (which caused the off-the-record warning)
    auto makeProfile = [&app](const QString &name) {
        auto *p = new QQuickWebEngineProfile(name, &app);
        p->setPersistentCookiesPolicy(QQuickWebEngineProfile::ForcePersistentCookies);
        return p;
    };
    QQuickWebEngineProfile *spotifyWebProfile    = makeProfile("spotify");
    QQuickWebEngineProfile *youtubeWebProfile    = makeProfile("youtube");
    youtubeWebProfile->setHttpUserAgent(
        "Mozilla/5.0 (Linux; Android 13; Pixel 7) "
        "AppleWebKit/537.36 (KHTML, like Gecko) "
        "Chrome/131.0.0.0 Mobile Safari/537.36");
    QQuickWebEngineProfile *huluWebProfile       = makeProfile("hulu");
    QQuickWebEngineProfile *netflixWebProfile    = makeProfile("netflix");
    QQuickWebEngineProfile *audibleWebProfile    = makeProfile("audible");
    QQuickWebEngineProfile *navigationWebProfile = makeProfile("navigation");
    unitsService.setDependencies(&vehicleState, &locationService, &settingsService);

    // Wire weather temp → locationService.outsideTemp
    // (replaced by physical sensor signal later — nothing else changes)
    QObject::connect(&weatherService, &WeatherService::currentTempChanged,
        [&weatherService, &locationService]() {
            locationService.setOutsideTemp(weatherService.currentTemp());
        });
    weatherService.setLocationService(&locationService);

    // Wire SpotifyService → MediaService so the cluster always shows active media
    auto syncSpotify = [&]() {
        mediaService.setAlbumArtUrl(spotifyService.albumArtUrl());
        mediaService.setTrackName(spotifyService.trackName());
        mediaService.setArtistName(spotifyService.artistName());
        mediaService.setAlbumName(spotifyService.albumName());
        mediaService.setIsPlaying(spotifyService.isPlaying());
        mediaService.setProgressMs(spotifyService.progressMs());
        mediaService.setDurationMs(spotifyService.durationMs());
        mediaService.setSourceName("Spotify");
    };
    QObject::connect(&spotifyService, &SpotifyService::trackNameChanged,    syncSpotify);
    QObject::connect(&spotifyService, &SpotifyService::albumArtUrlChanged,  syncSpotify);
    QObject::connect(&spotifyService, &SpotifyService::isPlayingChanged,    syncSpotify);
    QObject::connect(&spotifyService, &SpotifyService::progressMsChanged,   syncSpotify);
    QObject::connect(&spotifyService, &SpotifyService::durationMsChanged,   syncSpotify);

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
        engine.rootContext()->setContextProperty("weatherService", &weatherService);
        engine.rootContext()->setContextProperty("climateService", &climateService);
        engine.rootContext()->setContextProperty("spotifyService", &spotifyService);
        engine.rootContext()->setContextProperty("spotifyWebProfile",    spotifyWebProfile);
        engine.rootContext()->setContextProperty("youtubeWebProfile",    youtubeWebProfile);
        engine.rootContext()->setContextProperty("huluWebProfile",       huluWebProfile);
        engine.rootContext()->setContextProperty("netflixWebProfile",    netflixWebProfile);
        engine.rootContext()->setContextProperty("audibleWebProfile",    audibleWebProfile);
        engine.rootContext()->setContextProperty("navigationWebProfile", navigationWebProfile);
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