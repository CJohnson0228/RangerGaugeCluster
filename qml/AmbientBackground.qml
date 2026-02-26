import QtQuick
import HMItestUI

Item {
    id: root
    anchors.fill: parent

    Image {
        id: lightBG
        anchors.fill: parent
        source: Theme.imagePath + "bg_light.jpg"
        fillMode: Image.PreserveAspectCrop
        opacity: Theme.isDarkMode ? 0.0 : 1.0

        Behavior on opacity {
            NumberAnimation { duration: Theme.toggleTimer; easing.type: Easing.InOutQuad }
        }
    }

    Image {
        id: darkBG
        anchors.fill: parent
        source: Theme.imagePath + "bg_dark.jpg"
        fillMode: Image.PreserveAspectCrop
        opacity: Theme.isDarkMode ? 1.0 : 0.0

        Behavior on opacity {
            NumberAnimation { duration: Theme.toggleTimer; easing.type: Easing.InOutQuad }
        }
    }
}