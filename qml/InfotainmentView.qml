import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import HMItestUI

ApplicationWindow {
    id: window
    width: 1080
    height: 1920
    x: 0
    y: 0
    visible: true
    title: "Ranger Infotainment UI"
    color: themeService.background
    Behavior on color { ColorAnimation { duration: themeService.toggleTimer }}

    // Image Background
    AmbientBackground {
        id: ambientBackground
        Component.onCompleted: themeService.backgroundItem = ambientBackground
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        InfotainmentHeader {
            Layout.fillWidth: true
        }

        // Content area — Where App output will be at
        // (Spotify/Youtube/Navigation)
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        // Vehicle Data
        VehicleDataPanel {
            Layout.fillWidth: true
        }

        // Weather Display
        WeatherPanel {
            Layout.fillWidth: true
        }

        // Climate Controls
        ClimateControlPanel {
            Layout.fillWidth: true
        }

        // Control Buttons (app buttone)
        InfotainmentFooter {
            Layout.fillWidth: true
        }
    }
}