import QtQuick
import HMItestUI

Item {
    id: root

    property bool active: false
    signal clicked()

    // Any children placed inside HMIButton become the button's content
    default property alias contentData: contentSlot.data

    // Background
    Rectangle {
        anchors.fill: parent
        radius: 6
        color: root.active ? themeService.primary : themeService.card
        border.color: root.active ? themeService.primary : themeService.border
        border.width: 1
        Behavior on color        { ColorAnimation { duration: 150 }}
        Behavior on border.color { ColorAnimation { duration: 150 }}
    }

    // Content slot — children are centered inside
    Item {
        id: contentSlot
        anchors.fill: parent
    }

    scale: mouseArea.pressed ? 0.93 : 1.0
    Behavior on scale { NumberAnimation { duration: 80; easing.type: Easing.OutCubic }}

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: root.clicked()
    }
}
