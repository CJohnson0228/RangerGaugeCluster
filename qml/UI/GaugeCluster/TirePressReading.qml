import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import HMItestUI

Text {
    id: root
    property real tirePress
    text: tirePress.toFixed(1)
    font.family: themeService.fontOxanium
    font.pixelSize: 24
    color: themeService.foreground

    Behavior on color { ColorAnimation { duration: themeService.toggleTimer }}

    // Caution Low Pressure Indicator
    Shape {
        anchors.centerIn: parent
        width: 50
        height: 50
        visible: tirePress < unitsService.tirePressLowThreshold
        z: -1

        ShapePath {
            strokeWidth: 0
            strokeColor: "transparent"
            fillGradient: RadialGradient {
                centerX: 25; centerY: 25
                centerRadius: 25
                focalX: centerX; focalY: centerY
                GradientStop { position: 0.0; color: themeService.darkAccent }
                GradientStop { position: 1.0; color: "transparent" }
            }
            PathAngleArc {
                centerX: 25; centerY: 25
                radiusX: 25; radiusY: 25
                startAngle: 0; sweepAngle: 360
            }
        }

        SequentialAnimation on opacity {
            running: tirePress < unitsService.tirePressLowThreshold
            loops: Animation.Infinite
            NumberAnimation { to: 1.0; duration: 600; easing.type: Easing.InOutSine }
            NumberAnimation { to: 0.0; duration: 600; easing.type: Easing.InOutSine }
        }
    }

    // Warning HI Pressure Indicator
    Shape {
        anchors.centerIn: parent
        width: 50
        height: 50
        visible: tirePress > unitsService.tirePressHighThreshold
        z: -1

        ShapePath {
            strokeWidth: 0
            strokeColor: "transparent"
            fillGradient: RadialGradient {
                centerX: 25; centerY: 25
                centerRadius: 25
                focalX: centerX; focalY: centerY
                GradientStop { position: 0.0; color: themeService.error }
                GradientStop { position: 1.0; color: "transparent" }
            }
            PathAngleArc {
                centerX: 25; centerY: 25
                radiusX: 25; radiusY: 25
                startAngle: 0; sweepAngle: 360
            }
        }

        SequentialAnimation on opacity {
            running: tirePress > unitsService.tirePressHighThreshold
            loops: Animation.Infinite
            NumberAnimation { to: 1.0; duration: 600; easing.type: Easing.InOutSine }
            NumberAnimation { to: 0.0; duration: 600; easing.type: Easing.InOutSine }
        }
    }
}