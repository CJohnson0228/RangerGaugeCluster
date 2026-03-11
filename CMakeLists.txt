cmake_minimum_required(VERSION 4.1)
project(HMItest VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 COMPONENTS
        Core
        Quick
        Quick3D
        QuickControls2
        Network
        Sql
        Svg
        REQUIRED
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
        qml/UI/Infotainment/ClimateControl.qml
        qml/UI/Infotainment/InfotainmentFooter.qml
        qml/UI/Infotainment/FooterButton.qml
        qml/UI/Infotainment/RangerLogo.qml
        RESOURCES
        resources/fonts/BigShoulders.ttf
        resources/fonts/Quicksand.ttf
        resources/fonts/Oxanium.ttf
        resources/fonts/Orbitron.ttf
        resources/images/bg_dark.jpg
        resources/images/bg_light.jpg
        resources/images/tool.jpg
        resources/images/TopView.svg
        resources/icons/batterywarning.svg
        resources/icons/bluetooth-b.svg
        resources/icons/brakewarning.svg
        resources/icons/checkengine.svg
        resources/icons/coolanttempwarning.svg
        resources/icons/cog.svg
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
)

target_include_directories(HMItest PRIVATE ${CMAKE_CURRENT_SOURCE_DIR}/src)

include(GNUInstallDirs)
install(TARGETS HMItest
        BUNDLE DESTINATION .
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)