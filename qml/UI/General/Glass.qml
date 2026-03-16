import QtQuick
import QtQuick.Effects
import HMItestUI

Item {
    id: glass

    property real blurAmount: 0.6
    property real glassOpacity: 0.15
    property color tintColor: themeService.ring
    property real borderOpacity: 0.2
    property real borderWidth: 1
    property string borderStyle: "full"
    property real cornerRadius: 6

    // Glass
    Item {
        id: glassContent
        anchors.fill: parent

        layer.enabled: true
        layer.effect: MultiEffect {
            maskEnabled: true
            maskSource: ShaderEffectSource {
                sourceItem: Rectangle {
                    width: glassContent.width
                    height: glassContent.height
                    radius: glass.cornerRadius
                }
            }
            maskThresholdMin: 0.5
            maskSpreadAtMin: 1.0
        }

        ShaderEffectSource {
            id: effectSource
            anchors.fill: parent
            sourceItem: themeService.backgroundItem
            sourceRect: Qt.rect(
                glass.mapToItem(themeService.backgroundItem, 0, 0).x,
                glass.mapToItem(themeService.backgroundItem, 0, 0).y,
                glass.width,
                glass.height
            )
            visible: false
        }

        MultiEffect {
            id: blur
            anchors.fill: parent
            source: effectSource
            autoPaddingEnabled: false
            blurEnabled: true
            blurMax: 64
            blur: glass.blurAmount
            saturation: -0.2
        }

        Rectangle {
            id: tint
            anchors.fill: parent
            color: glass.tintColor
            opacity: glass.glassOpacity

            Behavior on color {
                ColorAnimation { duration: themeService.toggleTimer }
            }
        }

        // Border
        Rectangle {
            id: border
            anchors.fill: parent
            radius: glass.cornerRadius
            color: "transparent"
            border.width: glass.borderStyle === "full" ? glass.borderWidth : 0
            border.color: Qt.rgba(1, 1, 1, glass.borderOpacity)
        }

        Rectangle {
            id: bottomBorder
            visible: glass.borderStyle === "bottom"
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: glass.borderWidth
            color: Qt.rgba(1, 1, 1, glass.borderOpacity)
        }
    }

    // Shadow
    RectangularShadow {
        z: -1
        anchors.fill: parent
        radius: glass.cornerRadius
        color: Qt.rgba(0, 0, 0, 0.7)
        offset.x: 0
        offset.y: 0
        blur: 10
        spread: 3
    }
}