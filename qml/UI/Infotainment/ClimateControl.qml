import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import HMItestUI

Item {
    id: root
    width: parent.width
    height: 300

    RectangularShadow {
        anchors.fill: root
        radius: 3
        color: Qt.rgba(0, 0, 0, 0.7)
        offset.x: 0
        offset.y: 0
        blur: 10
        spread: 3
    }

    Rectangle {
        id: rectangle
        anchors.fill: parent
        border.color: themeService.border
        border.width: 1
        gradient: Gradient {
            orientation: Gradient.Vertical
            GradientStop { position: 0.0;  color: themeService.gradientOuter; Behavior on color { ColorAnimation { duration: themeService.toggleTimer }} }
            GradientStop { position: 0.05; color: themeService.gradientInner; Behavior on color { ColorAnimation { duration: themeService.toggleTimer }} }
            GradientStop { position: 0.95; color: themeService.gradientInner; Behavior on color { ColorAnimation { duration: themeService.toggleTimer }} }
            GradientStop { position: 1.0;  color: themeService.gradientOuter; Behavior on color { ColorAnimation { duration: themeService.toggleTimer }} }
        }
    }
}