import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.VirtualKeyboard
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

    property string currentApp: ""
    property bool vehicleDataExpanded: false

    // Image Background
    AmbientBackground {
        id: ambientBackground
        Component.onCompleted: themeService.backgroundItem = ambientBackground
    }

    // Virtual keyboard — overlays UI, anchored to bottom of window
    InputPanel {
        id: inputPanel
        z: 100
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        visible: active
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        InfotainmentHeader {
            Layout.fillWidth: true
        }

        // App viewport — panels below never move; only this area changes
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.leftMargin:  20
            Layout.rightMargin: 20
            Layout.topMargin: 20

            // ── Persistent apps (stay loaded, audio/GPS keeps running) ──────────
            Loader {
                anchors.fill: parent
                active: true
                visible: window.currentApp === "spotify"
                source: Qt.resolvedUrl("UI/Infotainment/apps/SpotifyApp.qml")
            }
            Loader {
                anchors.fill: parent
                active: true
                visible: window.currentApp === "audible"
                source: Qt.resolvedUrl("UI/Infotainment/apps/AudibleApp.qml")
            }
            Loader {
                anchors.fill: parent
                active: true
                visible: window.currentApp === "googlemaps"
                source: Qt.resolvedUrl("UI/Infotainment/apps/GoogleMapsApp.qml")
            }
            Loader {
                anchors.fill: parent
                active: true
                visible: window.currentApp === "navigation"
                source: Qt.resolvedUrl("UI/Infotainment/apps/NavigationApp.qml")
            }

            // ── On-demand apps ────────────────────────────────────────────────────
            Loader {
                anchors.fill: parent
                active: window.currentApp === "youtube"
                source: Qt.resolvedUrl("UI/Infotainment/apps/YoutubeApp.qml")
            }
            Loader {
                anchors.fill: parent
                active: window.currentApp === "hulu"
                source: Qt.resolvedUrl("UI/Infotainment/apps/HuluApp.qml")
            }
            Loader {
                anchors.fill: parent
                active: window.currentApp === "netflix"
                source: Qt.resolvedUrl("UI/Infotainment/apps/NetflixApp.qml")
            }
            Loader {
                anchors.fill: parent
                active: window.currentApp === "settings"
                source: Qt.resolvedUrl("UI/Infotainment/apps/SettingsApp.qml")
            }
        }

        // Vehicle Data
        VehicleDataPanel {
            Layout.fillWidth: true
            expanded: window.vehicleDataExpanded
        }

        // Weather Display
        WeatherPanel {
            Layout.fillWidth: true
        }

        // Climate Controls
        ClimateControlPanel {
            Layout.fillWidth: true
        }

        // Control Buttons (app buttons)
        InfotainmentFooter {
            Layout.fillWidth: true
            currentApp: window.currentApp
            vehicleDataExpanded: window.vehicleDataExpanded
            onAppTapped: (appId) => {
                if (appId === "truckData")
                    window.vehicleDataExpanded = !window.vehicleDataExpanded
                else
                    window.currentApp = (window.currentApp === appId) ? "" : appId
            }
        }
    }
}
