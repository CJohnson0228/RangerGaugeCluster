import QtQuick
import QtQuick.Shapes
import QtQuick.Effects
import HMItestUI

Item {
    id: root
    width: 394
    height: 394

    // Configuration
    property real minValue: 0
    property real maxValue: 120
    property real value: 0
    Behavior on value { NumberAnimation { duration: 200; easing.type: Easing.OutCubic }}

    property real startAngle: 150
    property real endAngle: 390
    property real sweepAngle: endAngle - startAngle

    property string unit: "MPH"
    property string label: ""
    property int decimals: 0

    property real arcWidth: 12
    property color arcBackgroundColor: Theme.card
    property color dialBackgroundColor: Theme.background
    property color arcColor: Theme.primary
    property color needleColor: Theme.foreground
    property color textColor: Theme.foreground
    property color labelColor: Theme.foreground

    readonly property real centerX: width / 2
    readonly property real centerY: height / 2
    readonly property real radius: Math.min(width, height) / 2 - 8
    readonly property real valueAngle: startAngle + (value - minValue) / (maxValue - minValue) * sweepAngle

    // Gauge Layers
    Item {
        id: gaugeContent
        anchors.fill: parent
        visible: false
        layer.enabled: true
        layer.samples: 4

        Rectangle {
            anchors.fill: parent
            color: root.dialBackgroundColor
            Behavior on color { ColorAnimation { duration: Theme.toggleTimer }}
        }

        // Speedo Arc
        Shape {
            anchors.fill: parent
            ShapePath {
                fillColor: "transparent"
                strokeColor: root.arcBackgroundColor
                strokeWidth: root.arcWidth
                capStyle: ShapePath.FlatCap
                PathAngleArc {
                    centerX: root.centerX
                    centerY: root.centerY
                    radiusX: root.radius
                    radiusY: root.radius
                    startAngle: root.startAngle
                    sweepAngle: root.sweepAngle
                }
                Behavior on strokeColor { ColorAnimation { duration: Theme.toggleTimer }}
            }
        }

        // Redline
        Shape {
            anchors.fill: parent
            ShapePath {
                fillColor: "transparent"
                strokeColor: Theme.error
                strokeWidth: root.arcWidth
                capStyle: ShapePath.FlatCap
                PathAngleArc {
                    centerX: root.centerX
                    centerY: root.centerY
                    radiusX: root.radius
                    radiusY: root.radius
                    startAngle: root.startAngle + (100 - root.minValue) / (root.maxValue - root.minValue) * root.sweepAngle
                    sweepAngle: (20 / (root.maxValue - root.minValue)) * root.sweepAngle
                }
                Behavior on strokeColor { ColorAnimation { duration: Theme.toggleTimer }}
            }
        }

        // Arc Value Fill
        Shape {
            anchors.fill: parent
            ShapePath {
                fillColor: "transparent"
                strokeColor: root.arcColor
                strokeWidth: root.arcWidth
                capStyle: ShapePath.FlatCap
                PathAngleArc {
                    centerX: root.centerX
                    centerY: root.centerY
                    radiusX: root.radius
                    radiusY: root.radius
                    startAngle: root.startAngle
                    sweepAngle: (root.valueAngle - root.startAngle)
                }
                Behavior on strokeColor { ColorAnimation { duration: Theme.toggleTimer }}
            }
        }

        // Tick Marks
        Repeater {
            model: 25
            Rectangle {
                property real tickAngle: root.startAngle + index * (root.sweepAngle / 24)
                property real tickRad: tickAngle * Math.PI / 180
                property bool isLabeled: index % 4 === 0
                property bool isMajor: index % 2 === 0
                property real tickHeight: isLabeled ? 18 : isMajor ? 14 : 6
                property real tickCenterRadius: root.radius + root.arcWidth / 2 - tickHeight / 2

                x: root.centerX + Math.cos(tickRad) * tickCenterRadius - width / 2
                y: root.centerY + Math.sin(tickRad) * tickCenterRadius - height / 2
                width: 2
                height: tickHeight
                radius: 1
                color: isMajor ? root.textColor : Theme.textMuted
                rotation: tickAngle + 90
                antialiasing: true
                Behavior on color { ColorAnimation { duration: Theme.toggleTimer }}
            }
        }

        // Tick Labels
        Repeater {
            model: 25
            Text {
                property real tickAngle: root.startAngle + index * (root.sweepAngle / 24)
                property real tickRad: tickAngle * Math.PI / 180
                property bool isLabeled: index % 4 === 0
                property real labelRadius: root.radius - root.arcWidth / 2 - 22

                visible: isLabeled
                x: root.centerX + Math.cos(tickRad) * labelRadius - width / 2
                y: root.centerY + Math.sin(tickRad) * labelRadius - height / 2
                text: (root.minValue + index * 5).toString()
                font.pixelSize: 14
                color: root.textColor
                horizontalAlignment: Text.AlignHCenter
                width: 30
                Behavior on color { ColorAnimation { duration: Theme.toggleTimer }}
            }
        }

        // Needle Sweep Effect
        Shape {
            anchors.fill: parent
            ShapePath {
                id: sweepPath
                property real sweepAngleRad: (root.valueAngle - root.startAngle) * Math.PI / 180
                property real sweepRadius: Math.max(root.radius, root.radius * sweepAngleRad)

                fillGradient: RadialGradient {
                    centerX: root.centerX + Math.cos(root.valueAngle * Math.PI / 180) * root.radius
                    centerY: root.centerY + Math.sin(root.valueAngle * Math.PI / 180) * root.radius
                    focalX: centerX
                    focalY: centerY
                    centerRadius: sweepPath.sweepRadius
                    GradientStop { position: 0.0; color: Qt.rgba(root.arcColor.r, root.arcColor.g, root.arcColor.b, 0.4) }
                    GradientStop { position: 1.0; color: "transparent" }
                }

                strokeColor: "transparent"
                strokeWidth: 0

                PathMove { x: root.centerX; y: root.centerY }
                PathLine {
                    x: root.centerX + Math.cos(root.startAngle * Math.PI / 180) * root.radius
                    y: root.centerY + Math.sin(root.startAngle * Math.PI / 180) * root.radius
                }
                PathAngleArc {
                    centerX: root.centerX
                    centerY: root.centerY
                    radiusX: root.radius
                    radiusY: root.radius
                    startAngle: root.startAngle
                    sweepAngle: (root.valueAngle - root.startAngle)
                }
                PathLine { x: root.centerX; y: root.centerY }
            }
        }

        // Needle
        Rectangle {
            id: needle
            width: 4
            height: root.radius
            radius: 1
            color: root.needleColor
            x: root.centerX - width / 2
            y: root.centerY - height
            transformOrigin: Item.Bottom
            rotation: root.valueAngle + 90
        }

        // Center Cover Shadow
        Rectangle {
            property real coverRadius: root.width * 0.4
            width: coverRadius + 7
            height: coverRadius + 7
            radius: width / 2
            anchors.centerIn: parent
            color: Qt.rgba(0, 0, 0, 0.6)
        }

        // Needle Cover
        Rectangle {
            property real coverRadius: root.width * 0.4
            width: coverRadius
            height: coverRadius
            radius: width / 2
            anchors.centerIn: parent
            border.color: Theme.border
            border.width: 1
            gradient: Gradient {
                orientation: Gradient.Vertical
                GradientStop { position: 0.0; color: Theme.darkGradientInner }
                GradientStop { position: 1.0; color: Theme.darkGradientOuter }
            }
        }

        // Center Label
        Column {
            anchors.centerIn: parent
            spacing: 2

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.value.toFixed(root.decimals)
                font.family: Theme.fontOxanium
                font.weight: Font.Bold
                font.pixelSize: 72
                color: Theme.darkForeground
                Behavior on color { ColorAnimation { duration: Theme.toggleTimer }}
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.unit
                font.family: Theme.fontQuicksand
                font.pixelSize: 16
                color: Theme.darkTextMuted
                Behavior on color { ColorAnimation { duration: Theme.toggleTimer }}
            }
        }
    }

    // Clip Mask
    Rectangle {
        id: circleMask
        anchors.fill: parent
        radius: width / 2
        visible: false
        layer.enabled: true
    }

    // MultiEffect composites them together
    MultiEffect {
        anchors.fill: parent
        source: gaugeContent
        maskEnabled: true
        maskSource: circleMask
    }
}