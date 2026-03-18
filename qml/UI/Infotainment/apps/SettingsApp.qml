import QtQuick
import HMItestUI

Item {
    anchors.fill: parent

    Column {
        anchors.centerIn: parent
        spacing: 20

        Image {
            anchors.horizontalCenter: parent.horizontalCenter
            width: 96; height: 96
            sourceSize.width: 96; sourceSize.height: 96
            source: themeService.iconPath + "settings.svg"
            fillMode: Image.PreserveAspectFit
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "SETTINGS"
            font.family: themeService.fontOxanium
            font.pixelSize: 28
            font.letterSpacing: 4
            color: themeService.textMuted
        }
    }
}
