import QtQuick
import QtQuick.Effects
import HMItestUI

Item {
    id: root
    property bool active: false
    property color pillColor: active ? Theme.darkPrimary : "transparent"
    property color textColor: active ? Theme.darkBackground : Theme.darkTextMuted
    property string label: ""
    property string iconSource: ""
    height: 30
    width: active ? 140 : 30
    Behavior on width { NumberAnimation { duration: 200; easing.type: Easing.OutCubic }}

    Rectangle {
        anchors.fill: parent
        radius: 18
        color: root.pillColor
        Behavior on color { ColorAnimation { duration: 200 }}
    }

    Image {
        id: icon
        anchors.left: parent.left
        anchors.leftMargin: 6
        anchors.verticalCenter: parent.verticalCenter
        width: 22
        height: 22
        source: root.iconSource
        fillMode: Image.PreserveAspectFit
        sourceSize.width: 22
        sourceSize.height: 22
        layer.enabled: true
        layer.effect: MultiEffect {
            colorization: 1.0
            colorizationColor: root.textColor
            Behavior on colorizationColor { ColorAnimation { duration: 200 }}
        }
    }

    Text {
        id: labelText
        anchors.left: icon.right
        anchors.leftMargin: 4
        anchors.verticalCenter: parent.verticalCenter
        text: root.label
        color: root.textColor
        font.family: Theme.fontQuicksand
        font.pixelSize: 16
        opacity: root.active ? 1.0 : 0.0
        Behavior on opacity { NumberAnimation { duration: 200 }}
        Behavior on color { ColorAnimation { duration: 200 }}
    }
}