import QtQuick
import HMItestUI

Item {
    id: root
    property string label: ""
    property string iconSource: ""
    width: 72
    height: 72

    Rectangle {
        anchors.fill: parent
        radius: 3
        color: "transparent"
        border.width: 1
        border.color: themeService.darkBorder
    }

    Image {
        anchors.centerIn: parent
        width: 50; height: 50
        sourceSize.width: 50; sourceSize.height: 50
        source: themeService.iconPath + root.iconSource
        fillMode: Image.PreserveAspectFit
    }
}