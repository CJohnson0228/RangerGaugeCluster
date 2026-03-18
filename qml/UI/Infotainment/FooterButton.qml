import QtQuick
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

    Rectangle {
        anchors.fill: parent
        radius: 3
        color: active ? Qt.rgba(themeService.primary.r, themeService.primary.g, themeService.primary.b, 0.2) : "transparent"
        border.width: active ? 2 : 1
        border.color: active ? themeService.primary : themeService.darkBorder
        Behavior on color       { ColorAnimation { duration: 150 }}
        Behavior on border.color { ColorAnimation { duration: 150 }}
    }

    Image {
        anchors.centerIn: parent
        width: 50; height: 50
        sourceSize.width: 50; sourceSize.height: 50
        source: themeService.iconPath + root.iconSource
        fillMode: Image.PreserveAspectFit
    }

    MouseArea {
        anchors.fill: parent
        onClicked: root.tapped(root.appId)
    }
}
