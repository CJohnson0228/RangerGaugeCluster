import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import HMItestUI

ApplicationWindow {
    id: window
    width: 1080
    height: 1920
    visible: true
    title: "Ranger Infotainment UI"
    color: themeService.background
    Behavior on color {
        ColorAnimation {
            duration: themeService.toggleTimer
        }
    }

    // Image Background
    AmbientBackground {
        id: ambientBackground
        Component.onCompleted: themeService.backgroundItem = ambientBackground
    }
}