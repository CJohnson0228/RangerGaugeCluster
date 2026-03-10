import QtQuick
import QtQuick.Effects
import HMItestUI

Item {
    id: root
    width: 35
    height: 35

    property bool active: false
    property string indicatorType: "caution"  // "warning" | "caution" | "info"
    property string iconSource: ""
    property color iconColor: active
        ? (indicatorType === "warning" ? themeService.error
         : indicatorType === "info"    ? themeService.success
         :                               themeService.accent)
        : themeService.darkBackground


    Image {
        anchors.fill: parent
        source: themeService.iconPath + root.iconSource
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