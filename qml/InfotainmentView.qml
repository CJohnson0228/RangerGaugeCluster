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
        }

        // Weather Display
        WeatherPanel {
            Layout.fillWidth: true
        }

        // Climate Controls
        ClimateControlPanel {
            Layout.fillWidth: true
        }

        // Virtual keyboard — floats above footer when a text field is active
        InputPanel {
            id: inputPanel
            Layout.fillWidth: true
            visible: active
        }

        // Control Buttons (app buttons)
        InfotainmentFooter {
            Layout.fillWidth: true
            currentApp: window.currentApp
            onAppTapped: (appId) => {
                window.currentApp = (window.currentApp === appId) ? "" : appId
            }
        }
    }
}
