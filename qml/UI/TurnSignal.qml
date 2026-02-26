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
    layer.enabled: true
    layer.effect: MultiEffect {
        shadowEnabled: true
        shadowColor: Theme.background
        Behavior on shadowColor { ColorAnimation { duration: 200 }}
        shadowScale: 1
        shadowVerticalOffset: 2
        shadowHorizontalOffset: 1
        shadowBlur: 0.4
    }

    Rectangle {
        anchors.fill: parent
        radius: 18
        gradient: Gradient {
            GradientStop { position: 0.0; color: Theme.darkGradientInner }
            GradientStop { position: 1.0; color: Theme.darkGradientOuter }
        }
        border.width: 1
        border.color: Theme.darkBorder
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