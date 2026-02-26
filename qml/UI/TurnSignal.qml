import QtQuick
import QtQuick.Shapes
import QtQuick.Effects
import HMItestUI

Item {
    id: root
    height: 36
    width: 36
    property bool active: false
    property color iconColor: active ? Theme.themeSuccess : "#000000"
    property string direction: "left"
    property string iconSource: root.direction === "left" ? Theme.iconPath + "arrow-small-left.svg" : Theme.iconPath + "arrow-small-right.svg"

    Rectangle {
        anchors.fill: parent
        radius: 18
        color: Theme.darkCard
        border.width: 1
        border.color: active ? Theme.themeSuccess : Theme.border
    }

    Image {
        id: blinker
        anchors.fill: parent
        source: root.iconSource
        sourceSize.width: width
        sourceSize.height: height
        visible: true
        layer.enabled: true
        layer.effect: MultiEffect {
            colorization: 1.0
            colorizationColor: root.iconColor
        }
    }
}