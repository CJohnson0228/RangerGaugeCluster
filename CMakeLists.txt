cmake_minimum_required(VERSION 4.1)
project(HMItest VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 COMPONENTS
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
)

set_source_files_properties(qml/theme/Theme.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

qt_add_qml_module(HMItest
        URI HMItestUI
        VERSION 1.0
        SOURCES
        QML_FILES
        qml/Main.qml
        qml/theme/Theme.qml
        qml/Speedo.qml
        qml/Tach.qml
        qml/InstrumentData.qml
        qml/WarningIndicators.qml
        qml/UI/TurnSignal.qml
        qml/UI/WarningIndicator.qml
        qml/UI/Media/MediaData.qml
        qml/UI/Media/MediaImage.qml
        qml/UI/Media/MediaProgress.qml
        RESOURCES
        resources/fonts/BigShoulders.ttf
        resources/fonts/Quicksand.ttf
        resources/fonts/Oxanium.ttf
        resources/icons/batterywarning.svg
        resources/icons/brakewarning.svg
        resources/icons/checkengine.svg
        resources/icons/coolanttempwarning.svg
        resources/icons/cruisecontrol.svg
        resources/icons/exclamation-circle.svg
        resources/icons/exclamation-triangle.svg
        resources/icons/fuellow.svg
        resources/icons/generalcaution.svg
        resources/icons/hazard.svg
        resources/icons/hibeam.svg
        resources/icons/lobeam.svg
        resources/icons/oilwarning.svg
        resources/icons/parkwarning.svg
        resources/icons/seatbeltwarning.svg
        resources/icons/tirepresswarning.svg
        resources/icons/washers.svg
        resources/icons/wipers.svg
        resources/icons/arrow-small-left.svg
        resources/icons/arrow-small-right.svg
)

set_target_properties(HMItest PROPERTIES
        MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
        MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
        MACOSX_BUNDLE TRUE
        WIN32_EXECUTABLE TRUE
)

target_link_libraries(HMItest
        PRIVATE
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