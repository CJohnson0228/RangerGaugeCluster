import QtQuick
import QtQuick.Effects
import QtQuick.Shapes
import HMItestUI

Item {
    id: root
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    width: 300
    height: 80

    readonly property real topWidth:    300
    readonly property real bottomWidth: 260
    readonly property real inset:       (topWidth - bottomWidth) / 2   // 20px each side

    Shape {
        id: trapezoid
        width:  root.topWidth
        height: root.height
        layer.enabled: true
        layer.samples: 4
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: Qt.rgba(0, 0, 0, 0.7)
            shadowHorizontalOffset: 0
            shadowVerticalOffset:   4
            shadowBlur:   0.6
            shadowScale:  1.0
        }

        ShapePath {
            strokeColor: themeService.border
            strokeWidth: 1

            fillGradient: LinearGradient {
                x1: 0; y1: 0
                x2: 0; y2: trapezoid.height
                GradientStop { position: 0.0;  color: themeService.gradientOuter }
                GradientStop { position: 0.15; color: themeService.gradientInner }
                GradientStop { position: 0.85; color: themeService.gradientInner }
                GradientStop { position: 1.0;  color: themeService.gradientOuter }
            }

            // Trapezoid: wide at top (0→300), narrow at bottom (20→280)
            startX: 0;                    startY: 0
            PathLine { x: root.topWidth;              y: 0             }
            PathLine { x: root.topWidth - root.inset; y: root.height   }
            PathLine { x: root.inset;                 y: root.height   }
            PathLine { x: 0;                          y: 0             }
        }
    }

    Text {
        anchors.centerIn: trapezoid
        text: "RANGER"
        font.family: themeService.fontOrbitron
        font.pixelSize: 32
        font.weight: Font.Bold
        color: themeService.foreground
        Behavior on color { ColorAnimation { duration: themeService.toggleTimer }}
    }
}
