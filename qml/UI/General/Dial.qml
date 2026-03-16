import QtQuick
import QtQuick.Shapes
import QtQuick.Effects
import HMItestUI

Item {
    id: dial
    width: 200
    height: 200

    // Configuration
    property real minValue: 60
    property real maxValue: 90
    property real value: 70
    property bool animated: true
    Behavior on value { enabled: dial.animated; NumberAnimation { duration: 200; easing.type: Easing.OutCubic }}

    property real startAngle: 135
    property real endAngle:   405
    property real sweepAngle: endAngle - startAngle

    property string unit:    "°F"
    property string label:   ""
    property int    decimals: 0

    // Appearance
    property real  arcWidth:          12
    property color arcBackgroundColor: themeService.card
    property color dialBackgroundColor: themeService.background
    property color arcStartColor:      "#4488ff"
    property color arcEndColor:        themeService.error
    property color needleColor:        themeService.foreground
    property color textColor:          themeService.darkForeground
    property color labelColor:         themeService.darkPrimary

    // Internal
    readonly property real centerX:   width / 2
    readonly property real centerY:   height / 2
    readonly property real radius:    Math.min(width, height) / 2 - arcWidth
    readonly property real valueAngle: startAngle + (value - minValue) / (maxValue - minValue) * sweepAngle

    // ── Gauge content (rendered to texture for circular masking) ─────────────
    Item {
        id: dialContent
        anchors.fill: parent
        visible: false
        layer.enabled: true
        layer.samples: 4

        // Background fill
        Rectangle {
            anchors.fill: parent
            color: dial.dialBackgroundColor
            Behavior on color { ColorAnimation { duration: themeService.toggleTimer }}
        }

        // Background Arc Track with rim glow
        Shape {
            anchors.fill: parent
            ShapePath {
                fillGradient: RadialGradient {
                    centerX: dial.centerX; centerY: dial.centerY
                    focalX:  dial.centerX; focalY:  dial.centerY
                    centerRadius: dial.radius
                    GradientStop { position: 0.0; color: dial.dialBackgroundColor;   Behavior on color { ColorAnimation { duration: themeService.toggleTimer }} }
                    GradientStop { position: 0.7; color: dial.dialBackgroundColor;   Behavior on color { ColorAnimation { duration: themeService.toggleTimer }} }
                    GradientStop { position: 1.0; color: dial.arcEndColor;   Behavior on color { ColorAnimation { duration: themeService.toggleTimer }} }
                }
                strokeColor: dial.arcBackgroundColor
                strokeWidth: dial.arcWidth
                capStyle: ShapePath.FlatCap
                PathAngleArc {
                    centerX: dial.centerX; centerY: dial.centerY
                    radiusX: dial.radius;  radiusY: dial.radius
                    startAngle: dial.startAngle; sweepAngle: dial.sweepAngle
                }
                Behavior on strokeColor { ColorAnimation { duration: themeService.toggleTimer }}
            }
        }

        // Active Value Arc
        Shape {
            anchors.fill: parent
            ShapePath {
                fillColor:   "transparent"
                strokeColor: dial.arcEndColor
                strokeWidth: dial.arcWidth
                capStyle:    ShapePath.FlatCap
                PathAngleArc {
                    centerX: dial.centerX; centerY: dial.centerY
                    radiusX: dial.radius;  radiusY: dial.radius
                    startAngle:  dial.startAngle
                    sweepAngle:  (dial.value - dial.minValue) / (dial.maxValue - dial.minValue) * dial.sweepAngle
                }
                Behavior on strokeColor { ColorAnimation { duration: 300 }}
            }
        }

        // Tick Marks
        Repeater {
            model: 13
            Rectangle {
                required property int index
                property real tickAngle:        dial.startAngle + index * (dial.sweepAngle / 12)
                property real tickRad:          tickAngle * Math.PI / 180
                property bool isMajor:          index % 3 === 0
                property real tickHeight:       isMajor ? 14 : 6
                property real tickCenterRadius: dial.radius - dial.arcWidth / 2 - tickHeight / 2

                x: dial.centerX + Math.cos(tickRad) * tickCenterRadius - width / 2
                y: dial.centerY + Math.sin(tickRad) * tickCenterRadius - height / 2
                width: 2; height: tickHeight; radius: 1
                color: isMajor ? dial.textColor : themeService.textMuted
                rotation: tickAngle + 90
                antialiasing: true
                Behavior on color { ColorAnimation { duration: themeService.toggleTimer }}
            }
        }

        // Needle
        Rectangle {
            width: 3
            height: dial.radius - 4
            radius: 2
            color: dial.needleColor
            x: dial.centerX - width / 2
            y: dial.centerY - height
            transformOrigin: Item.Bottom
            rotation: dial.valueAngle + 90
            Behavior on color { ColorAnimation { duration: themeService.toggleTimer }}
        }

        // Center cover shadow
        Rectangle {
            property real sz: dial.width * 0.4 + 6
            width: sz; height: sz; radius: sz / 2
            anchors.centerIn: parent
            color: Qt.rgba(0, 0, 0, 0.6)
        }

        // Center cover — dark gradient circle matching Speedo/Tach
        Rectangle {
            property real sz: dial.width * 0.4
            width: sz; height: sz; radius: sz / 2
            anchors.centerIn: parent
            border.color: themeService.darkBorder
            border.width: 1
            gradient: Gradient {
                orientation: Gradient.Vertical
                GradientStop { position: 0.0; color: themeService.darkGradientInner }
                GradientStop { position: 1.0; color: themeService.darkGradientOuter }
            }
        }

        // Center value + unit
        Column {
            anchors.centerIn: parent
            // anchors.verticalCenterOffset: dial.label !== "" ? -8 : 0
            spacing: 0

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: dial.value.toFixed(dial.decimals)
                font.family: themeService.fontOxanium
                font.pixelSize: dial.width * 0.16
                font.weight: Font.Bold
                color: dial.textColor
                Behavior on color { ColorAnimation { duration: themeService.toggleTimer }}
            }
            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: dial.unit
                font.family: themeService.fontOxanium
                font.pixelSize: dial.width * 0.08
                color: themeService.darkTextMuted
                Behavior on color { ColorAnimation { duration: themeService.toggleTimer }}
            }
        }

        // Label badge at bottom
        Rectangle {
            visible: dial.label !== ""
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: dial.width * 0.1
            width: dial.width * 0.54; height: 26; radius: 10
            color: dial.dialBackgroundColor
            Behavior on color { ColorAnimation { duration: themeService.toggleTimer }}
            Text {
                anchors.centerIn: parent
                text: dial.label
                font.family: themeService.fontOrbitron
                font.pixelSize: dial.width * 0.08
                color: dial.labelColor
                Behavior on color { ColorAnimation { duration: themeService.toggleTimer }}
            }
        }
    }

    // ── Circular clip mask ───────────────────────────────────────────────────
    Rectangle {
        id: circleMask
        anchors.fill: parent
        radius: width / 2
        visible: false
        layer.enabled: true
    }

    // ── Composite with circle mask ───────────────────────────────────────────
    MultiEffect {
        anchors.fill: parent
        source: dialContent
        maskEnabled: true
        maskSource: circleMask
    }

    // ── Touch interaction ────────────────────────────────────────────────────
    MouseArea {
        anchors.fill: parent

        function angleFromPoint(px, py) {
            var angle = Math.atan2(py - dial.centerY, px - dial.centerX) * 180 / Math.PI
            if (angle < 0) angle += 360
            return angle
        }

        function angleToValue(angle) {
            var relative = angle - dial.startAngle
            if (relative < 0) relative += 360
            if (relative > dial.sweepAngle) {
                return (relative < 360 - dial.sweepAngle + relative)
                    ? dial.minValue : dial.maxValue
            }
            return dial.minValue + (relative / dial.sweepAngle) * (dial.maxValue - dial.minValue)
        }

        onPressed:         function(e) { dial.value = angleToValue(angleFromPoint(e.x, e.y)) }
        onPositionChanged: function(e) { if (pressed) dial.value = angleToValue(angleFromPoint(e.x, e.y)) }
    }
}
