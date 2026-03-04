import QtQuick
import QtQuick.Shapes
import QtQuick.Effects
import HMItestUI

Item {
    id: root
    width: 394
    height: 394

    // Configuration
    property int minValue: 0
    property int maxValue: 7
    property real value: vehicleState.engineRPM / 1000
    Behavior on value { NumberAnimation { duration: 200; easing.type: Easing.OutCubic }}

    property real startAngle: 150
    property real endAngle: 390
    property real sweepAngle: endAngle - startAngle

    property string unit: "RPM x 1000"
    property string label: ""
    property int decimals: 1

    property real arcWidth: 12
    property color arcBackgroundColor: themeService.card
    property color dialBackgroundColor: themeService.background
    property color arcColor: themeService.primary
    property color needleColor: themeService.foreground
    property color textColor: themeService.foreground
    property color labelColor: themeService.foreground

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
            Behavior on color { ColorAnimation { duration: themeService.toggleTimer }}
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
                Behavior on strokeColor { ColorAnimation { duration: themeService.toggleTimer }}
            }
        }

        // Redline
        Shape {
            anchors.fill: parent
            ShapePath {
                fillColor: "transparent"
                strokeColor: themeService.error
                strokeWidth: root.arcWidth
                capStyle: ShapePath.FlatCap
                PathAngleArc {
                    centerX: root.centerX
                    centerY: root.centerY
                    radiusX: root.radius
                    radiusY: root.radius
                    startAngle: root.startAngle + (5 - root.minValue) / (root.maxValue - root.minValue) * root.sweepAngle
                    sweepAngle: (2 / (root.maxValue - root.minValue)) * root.sweepAngle
                }
                Behavior on strokeColor { ColorAnimation { duration: themeService.toggleTimer }}
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
                Behavior on strokeColor { ColorAnimation { duration: themeService.toggleTimer }}
            }
        }

        // Tick Marks
        Repeater {
            model: 15
            Rectangle {
                property real tickAngle: root.startAngle + index * (root.sweepAngle / 14)
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
                color: isMajor ? root.textColor : themeService.textMuted
                rotation: tickAngle + 90
                antialiasing: true
                Behavior on color { ColorAnimation { duration: themeService.toggleTimer }}
            }
        }

        // Tick Labels
        Repeater {
            model: 15
            Text {
                property real tickAngle: root.startAngle + index * (root.sweepAngle / 14)
                property real tickRad: tickAngle * Math.PI / 180
                property bool isLabeled: index % 2 === 0
                property real labelRadius: root.radius - root.arcWidth / 2 - 22

                visible: isLabeled
                x: root.centerX + Math.cos(tickRad) * labelRadius - width / 2
                y: root.centerY + Math.sin(tickRad) * labelRadius - height / 2
                text: (root.minValue + index * 0.5).toFixed(1)
                font.pixelSize: 14
                color: root.textColor
                horizontalAlignment: Text.AlignHCenter
                width: 30
                Behavior on color { ColorAnimation { duration: themeService.toggleTimer }}
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
            Behavior on color { ColorAnimation { duration: themeService.toggleTimer }}
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
            border.color: themeService.darkBorder
            border.width: 1
            gradient: Gradient {
                orientation: Gradient.Vertical
                GradientStop { position: 0.0; color: themeService.darkGradientInner }
                GradientStop { position: 1.0; color: themeService.darkGradientOuter }
            }
        }

        // Center Label
        Column {
            anchors.centerIn: parent
            spacing: 2

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.value.toFixed(root.decimals)
                font.family: themeService.fontOxanium
                font.weight: Font.Bold
                font.pixelSize: 72
                color: themeService.darkForeground
                Behavior on color { ColorAnimation { duration: themeService.toggleTimer }}
            }

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: root.unit
                font.family: themeService.fontQuicksand
                font.pixelSize: 16
                color: themeService.darkTextMuted
                Behavior on color { ColorAnimation { duration: themeService.toggleTimer }}
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