import QtQuick
import QtQuick.Effects
import HMItestUI

Item {
    id: root
    property string label: ""
    property string iconSource: ""
    property string appId: ""
    property bool active: false

    signal tapped(string appId)

    width: 72
    height: 72

    scale: mouseArea.pressed ? 0.88 : 1.0
    Behavior on scale { NumberAnimation { duration: 100; easing.type: Easing.OutCubic }}

    Image {
        anchors.centerIn: parent
        anchors.verticalCenterOffset: -3
        width: 46; height: 46
        sourceSize.width: 46; sourceSize.height: 46
        source: themeService.iconPath + root.iconSource
        fillMode: Image.PreserveAspectFit
        layer.enabled: true
        layer.effect: MultiEffect {
            colorization: root.active ? 0.0 : 1.0
            colorizationColor: themeService.darkTextMuted
            Behavior on colorization { NumberAnimation { duration: 180 }}
        }
    }

    // Active indicator bar
    Rectangle {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        width: root.active ? 28 : 6
        height: 3
        radius: 2
        color: themeService.primary
        opacity: root.active ? 1.0 : 0.0
        Behavior on width   { NumberAnimation { duration: 220; easing.type: Easing.OutCubic }}
        Behavior on opacity { NumberAnimation { duration: 180 }}
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: root.tapped(root.appId)
    }
}
