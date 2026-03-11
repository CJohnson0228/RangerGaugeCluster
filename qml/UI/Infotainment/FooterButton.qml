import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import HMItestUI

Item {
    id: root
    property string label: ""
    property color iconColor: themeService.darkForeground
    property string iconSource: ""
    width: 75
    height: 75

    Rectangle {
        anchors.fill: parent
        radius: 3
        gradient: Gradient {
            orientation: Gradient.Vertical
            GradientStop { position: 0.0;  color: themeService.darkGradientOuter }
            GradientStop { position: 0.15; color: themeService.darkGradientInner }
            GradientStop { position: 0.85; color: themeService.darkGradientInner }
            GradientStop { position: 1.0;  color: themeService.darkGradientOuter }
        }
    }

    Image {
        anchors.centerIn: parent
        width: 50; height: 50
        sourceSize.width: 50; sourceSize.height: 50
        source: themeService.iconPath + root.iconSource
        fillMode: Image.PreserveAspectFit
        layer.enabled: true
        layer.effect: MultiEffect {
            colorization: 1.0
            colorizationColor: root.iconColor
            Behavior on colorizationColor { ColorAnimation { duration: 300 }}
        }
    }
}