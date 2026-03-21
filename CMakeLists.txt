cmake_minimum_required(VERSION 4.1)
project(HMItest VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# MapLibre Native Qt — built and installed separately via scripts/build-maplibre.sh
# Install prefix: ~/Qt/maplibre-qt
find_package(QMapLibre REQUIRED COMPONENTS Core QuickPrivate Location
    PATHS "$ENV{HOME}/Qt/maplibre-qt"
    NO_DEFAULT_PATH
)

find_package(Qt6 REQUIRED COMPONENTS
        Core
        Quick
        Quick3D
        QuickControls2
        Network
        Sql
        Svg
        WebEngineQuick
        VirtualKeyboard
        Location
        Positioning
)

qt_standard_project_setup(REQUIRES 6.10)

qt_add_executable(HMItest
        src/main.cpp
        src/VehicleState.h
        src/VehicleState.cpp
        src/ThemeService.h
        src/ThemeService.cpp
        src/LocationService.cpp
        src/LocationService.h
        src/SettingsService.cpp
        src/SettingsService.h
        src/MediaService.cpp
        src/MediaService.h
        src/UnitsService.cpp
        src/UnitsService.h
        src/ConnectivityService.h
        src/WeatherService.h
        src/WeatherService.cpp
        src/ClimateService.h
        src/SpotifyService.h
        src/SpotifyService.cpp
        src/NavigationService.h
        src/NavigationService.cpp
)


qt_add_qml_module(HMItest
        URI HMItestUI
        VERSION 1.0
        SOURCES
        QML_FILES
        qml/DevPanel.qml
        qml/ClusterView.qml
        qml/InfotainmentView.qml
        qml/AmbientBackground.qml
        qml/UI/General/Glass.qml
        qml/UI/General/Paper.qml
        qml/UI/General/Card.qml
        qml/UI/General/Dial.qml
        qml/UI/GaugeCluster/DataIcon.qml
        qml/UI/GaugeCluster/InstrumentData.qml
        qml/UI/GaugeCluster/Speedo.qml
        qml/UI/GaugeCluster/Media.qml
        qml/UI/GaugeCluster/Settings.qml
        qml/UI/GaugeCluster/SettingsRow.qml
        qml/UI/GaugeCluster/Tach.qml
        qml/UI/GaugeCluster/TirePressReading.qml
        qml/UI/GaugeCluster/TurnSignal.qml
        qml/UI/GaugeCluster/VehicleData.qml
        qml/UI/GaugeCluster/WarningIndicator.qml
        qml/UI/GaugeCluster/WarningIndicators.qml
        qml/UI/GaugeCluster/GeneralReadouts.qml
        qml/UI/Infotainment/InfotainmentHeader.qml
        qml/UI/Infotainment/ClimateControlPanel.qml
        qml/UI/Infotainment/WeatherPanel.qml
        qml/UI/Infotainment/VehicleDataPanel.qml
        qml/UI/Infotainment/InfotainmentFooter.qml
        qml/UI/Infotainment/FooterButton.qml
        qml/UI/Infotainment/RangerLogo.qml
        qml/UI/Infotainment/apps/WebAppView.qml
        qml/UI/Infotainment/apps/AudibleApp.qml
        qml/UI/Infotainment/apps/SpotifyApp.qml
        qml/UI/Infotainment/apps/YoutubeApp.qml
        qml/UI/Infotainment/apps/GoogleMapsApp.qml
        qml/UI/Infotainment/apps/HuluApp.qml
        qml/UI/Infotainment/apps/NetflixApp.qml
        qml/UI/Infotainment/apps/NavigationApp.qml
        qml/UI/Infotainment/apps/SettingsApp.qml
        RESOURCES
        resources/fonts/BigShoulders.ttf
        resources/fonts/Quicksand.ttf
        resources/fonts/Oxanium.ttf
        resources/fonts/Orbitron.ttf
        resources/images/weather/clearday.png
        resources/images/weather/clearnight.png
        resources/images/weather/partlycloudyday.png
        resources/images/weather/partlycloudynight.png
        resources/images/weather/overcast.png
        resources/images/weather/foggy.png
        resources/images/weather/rainingday.png
        resources/images/weather/rainingnight.png
        resources/images/weather/showersday.png
        resources/images/weather/showersnight.png
        resources/images/weather/snowingday.png
        resources/images/weather/snowingnight.png
        resources/images/weather/thunderstorms.png
        resources/images/weather/sleet.png
        resources/images/bg_dark.jpg
        resources/images/bg_light.jpg
        resources/images/tool.jpg
        resources/images/TopView.svg
        resources/icons/ClimateControl/vents.svg
        resources/icons/ClimateControl/floorvents.svg
        resources/icons/ClimateControl/defrost.svg
        resources/icons/ClimateControl/floordefrost.svg
        resources/icons/ClimateControl/floor.svg
        resources/icons/ClimateControl/fan.svg
        resources/icons/batterywarning.svg
        resources/icons/audible.svg
        resources/icons/bluetooth-b.svg
        resources/icons/brakewarning.svg
        resources/icons/checkengine.svg
        resources/icons/coolanttempwarning.svg
        resources/icons/hulu.svg
        resources/icons/netflix.svg
        resources/icons/google-maps.svg
        resources/icons/maps.svg
        resources/icons/settings.svg
        resources/icons/cruisecontrol.svg
        resources/icons/exclamation-circle.svg
        resources/icons/exclamation-triangle.svg
        resources/icons/fuellow.svg
        resources/icons/generalcaution.svg
        resources/icons/hazard.svg
        resources/icons/hibeam.svg
        resources/icons/lobeam.svg
        resources/icons/map-marked-alt.svg
        resources/icons/oilwarning.svg
        resources/icons/parkwarning.svg
        resources/icons/seatbeltwarning.svg
        resources/icons/spotify.svg
        resources/icons/tirepresswarning.svg
        resources/icons/washers.svg
        resources/icons/wipers.svg
        resources/icons/arrow-small-left.svg
        resources/icons/arrow-small-right.svg
        resources/icons/bluetooth.svg
        resources/icons/gear.svg
        resources/icons/music.svg
        resources/icons/pickup-truck.svg
        resources/icons/youtube.svg
)


set_target_properties(HMItest PROPERTIES
        MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
        MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
        MACOSX_BUNDLE TRUE
        WIN32_EXECUTABLE TRUE
)

target_link_libraries(HMItest
        PRIVATE
        Qt6::Core
        Qt6::Quick
        Qt6::Quick3D
        Qt6::QuickControls2
        Qt6::Network
        Qt6::Sql
        Qt6::Svg
        Qt6::WebEngineQuick
        Qt6::VirtualKeyboard
        Qt6::Location
        Qt6::Positioning
        QMapLibre::Location
        QMapLibre::QuickPrivate
)

target_include_directories(HMItest PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/src)

include(GNUInstallDirs)
install(TARGETS HMItest
        BUNDLE DESTINATION .
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)