import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import HMItestUI

Text {
    id: root
    property int tirePress
    text: tirePress
    font.family: Theme.fontOxanium
    font.pixelSize: 24
    color: Theme.foreground

    Behavior on color { ColorAnimation { duration: Theme.toggleTimer }}

    // Caution Low Pressure Indicator
    Shape {
        anchors.centerIn: parent
        width: 50
        height: 50
        visible: tirePress < 30
        z: -1

        ShapePath {
            strokeWidth: 0
            strokeColor: "transparent"
            fillGradient: RadialGradient {
                centerX: 25; centerY: 25
                centerRadius: 25
                focalX: centerX; focalY: centerY
                GradientStop { position: 0.0; color: Theme.darkAccent }
                GradientStop { position: 1.0; color: "transparent" }
            }
            PathAngleArc {
                centerX: 25; centerY: 25
                radiusX: 25; radiusY: 25
                startAngle: 0; sweepAngle: 360
            }
        }

        SequentialAnimation on opacity {
            running: tirePress < 30
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
        visible: tirePress > 40
        z: -1

        ShapePath {
            strokeWidth: 0
            strokeColor: "transparent"
            fillGradient: RadialGradient {
                centerX: 25; centerY: 25
                centerRadius: 25
                focalX: centerX; focalY: centerY
                GradientStop { position: 0.0; color: Theme.error }
                GradientStop { position: 1.0; color: "transparent" }
            }
            PathAngleArc {
                centerX: 25; centerY: 25
                radiusX: 25; radiusY: 25
                startAngle: 0; sweepAngle: 360
            }
        }

        SequentialAnimation on opacity {
            running: tirePress > 40
            loops: Animation.Infinite
            NumberAnimation { to: 1.0; duration: 600; easing.type: Easing.InOutSine }
            NumberAnimation { to: 0.0; duration: 600; easing.type: Easing.InOutSine }
        }
    }
}