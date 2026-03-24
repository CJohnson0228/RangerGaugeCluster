import QtQuick
import QtQuick.Shapes
import QtQuick.Effects
import HMItestUI

Item {
    id: root
    width: 240
    height: 240

    // ── Derived display values ───────────────────────────────────────────────
    readonly property real rawC:     climateService.temperature
    readonly property real minC:     15
    readonly property real maxC:     32
    readonly property real dispTemp: settingsService.metricUnits ? rawC : rawC * 9 / 5 + 32
    readonly property real minDisp:  settingsService.metricUnits ? minC : 60
    readonly property real maxDisp:  settingsService.metricUnits ? maxC : 90
    readonly property string unit:   settingsService.metricUnits ? "°C" : "°F"

    readonly property real progress: Math.max(0.0, Math.min(1.0, (dispTemp - minDisp) / (maxDisp - minDisp)))
    readonly property bool warm:     progress > 0.55

    // ── Arc geometry ─────────────────────────────────────────────────────────
    readonly property real arcCX:     width  / 2
    readonly property real arcCY:     height / 2
    readonly property real arcR:      width  / 2 - 10
    readonly property real arcStart:  135
    readonly property real arcSweep:  270

    // ── Background track ─────────────────────────────────────────────────────
    Shape {
        anchors.fill: parent
        ShapePath {
            fillColor:   "transparent"
            strokeColor: themeService.card
            strokeWidth: 10
            capStyle:    ShapePath.RoundCap
            PathAngleArc {
                centerX: root.arcCX;  centerY: root.arcCY
                radiusX: root.arcR;   radiusY: root.arcR
                startAngle: root.arcStart
                sweepAngle: root.arcSweep
            }
            Behavior on strokeColor { ColorAnimation { duration: themeService.toggleTimer }}
        }
    }

    // ── Value fill arc ───────────────────────────────────────────────────────
    Shape {
        anchors.fill: parent
        visible: root.progress > 0.01
        ShapePath {
            id: fillPath
            fillColor:   "transparent"
            strokeColor: root.warm ? themeService.error : themeService.info
            strokeWidth: 10
            capStyle:    ShapePath.RoundCap
            PathAngleArc {
                centerX: root.arcCX;  centerY: root.arcCY
                radiusX: root.arcR;   radiusY: root.arcR
                startAngle: root.arcStart
                sweepAngle: root.progress * root.arcSweep
            }
            Behavior on strokeColor { ColorAnimation { duration: 300 }}
        }
    }

    // ── Center readout ───────────────────────────────────────────────────────
    Column {
        anchors.centerIn: parent
        spacing: 2

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.dispTemp.toFixed(settingsService.metricUnits ? 1 : 0)
            font.family: themeService.fontOxanium
            font.pixelSize: 58
            font.weight: Font.Bold
            color: themeService.foreground
            Behavior on color { ColorAnimation { duration: themeService.toggleTimer }}
        }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.unit
            font.family: themeService.fontOxanium
            font.pixelSize: 17
            color: themeService.textMuted
            Behavior on color { ColorAnimation { duration: themeService.toggleTimer }}
        }
        Item { width: 1; height: 4 }
        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "TEMP"
            font.family: themeService.fontOrbitron
            font.pixelSize: 10
            color: themeService.primary
            Behavior on color { ColorAnimation { duration: themeService.toggleTimer }}
        }
    }

    // ── Minus button (lower-left of ring) ───────────────────────────────────
    Rectangle {
        anchors.left:           parent.left
        anchors.bottom:         parent.bottom
        anchors.leftMargin:     4
        anchors.bottomMargin:   4
        width: 44; height: 44; radius: 22
        color: minMA.pressed
            ? Qt.rgba(themeService.primary.r, themeService.primary.g, themeService.primary.b, 0.25)
            : themeService.card
        border.color: themeService.border
        border.width: 1
        scale: minMA.pressed ? 0.88 : 1.0
        Behavior on color { ColorAnimation { duration: 100 }}
        Behavior on scale { NumberAnimation { duration: 80 }}

        Text {
            anchors.centerIn: parent
            text: "−"
            font.pixelSize: 30
            font.weight: Font.Light
            color: themeService.foreground
            Behavior on color { ColorAnimation { duration: themeService.toggleTimer }}
        }
        MouseArea {
            id: minMA
            anchors.fill: parent
            onClicked: {
                var stepC = settingsService.metricUnits ? 0.5 : (5.0 / 9.0)
                climateService.temperature = Math.max(root.minC, root.rawC - stepC)
            }
        }
    }

    // ── Plus button (lower-right of ring) ────────────────────────────────────
    Rectangle {
        anchors.right:          parent.right
        anchors.bottom:         parent.bottom
        anchors.rightMargin:    4
        anchors.bottomMargin:   4
        width: 44; height: 44; radius: 22
        color: plusMA.pressed
            ? Qt.rgba(themeService.primary.r, themeService.primary.g, themeService.primary.b, 0.25)
            : themeService.card
        border.color: themeService.border
        border.width: 1
        scale: plusMA.pressed ? 0.88 : 1.0
        Behavior on color { ColorAnimation { duration: 100 }}
        Behavior on scale { NumberAnimation { duration: 80 }}

        Text {
            anchors.centerIn: parent
            text: "+"
            font.pixelSize: 26
            font.weight: Font.Light
            color: themeService.foreground
            Behavior on color { ColorAnimation { duration: themeService.toggleTimer }}
        }
        MouseArea {
            id: plusMA
            anchors.fill: parent
            onClicked: {
                var stepC = settingsService.metricUnits ? 0.5 : (5.0 / 9.0)
                climateService.temperature = Math.min(root.maxC, root.rawC + stepC)
            }
        }
    }
}
