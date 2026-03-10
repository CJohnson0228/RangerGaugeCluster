// SettingsRow.qml
import QtQuick
import HMItestUI

Item {
    id: root
    height: 44
    signal tapped()

    property string label: ""
    property string valueText: ""

    Rectangle {
        anchors.fill: parent
        color: rowMouse.containsMouse ? themeService.muted : "transparent"
        Behavior on color { ColorAnimation { duration: 100 }}

        Rectangle {
            anchors.bottom: parent.bottom
            width: parent.width
            height: 1
            color: themeService.border
            Behavior on color { ColorAnimation { duration: themeService.toggleTimer }}
        }

        Text {
            anchors.left: parent.left
            anchors.leftMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            text: root.label
            font.family: themeService.fontOxanium
            font.pixelSize: 14
            color: themeService.foreground
            Behavior on color { ColorAnimation { duration: themeService.toggleTimer }}
        }

        Text {
            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.verticalCenter: parent.verticalCenter
            text: root.valueText
            font.family: themeService.fontOxanium
            font.pixelSize: 14
            color: themeService.primary
            Behavior on color { ColorAnimation { duration: themeService.toggleTimer }}
        }
    }

    MouseArea {
        id: rowMouse
        anchors.fill: parent
        hoverEnabled: true
        onClicked: root.tapped()
    }
}