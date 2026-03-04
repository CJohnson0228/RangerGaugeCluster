import QtQuick
import HMItestUI

Item {
    id: root
    anchors.fill: parent

    Component.onCompleted: themeService.backgroundItem = root

    Image {
        id: lightBG
        anchors.fill: parent
        source: themeService.imagePath + "bg_light.jpg"
        fillMode: Image.PreserveAspectCrop
        opacity: themeService.darkMode ? 0.0 : 1.0
        Behavior on opacity {
            NumberAnimation { duration: themeService.toggleTimer; easing.type: Easing.InOutQuad }
        }
    }

    Image {
        id: darkBG
        anchors.fill: parent
        source: themeService.imagePath + "bg_dark.jpg"
        fillMode: Image.PreserveAspectCrop
        opacity: themeService.darkMode ? 1.0 : 0.0
        Behavior on opacity {
            NumberAnimation { duration: themeService.toggleTimer; easing.type: Easing.InOutQuad }
        }
    }
}