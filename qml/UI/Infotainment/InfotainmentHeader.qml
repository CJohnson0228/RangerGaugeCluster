import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import HMItestUI

Item {
    id: root
    width: parent.width
    height: 60

    RectangularShadow {
        anchors.fill: root
        radius: 3
        color: Qt.rgba(0, 0, 0, 0.7)
        offset.x: 0
        offset.y: 3
        blur: 10
        spread: 3
    }

    Rectangle {
        id: rectangle
        anchors.fill: parent
        border.color: themeService.darkBorder
        border.width: 1
        gradient: Gradient {
            orientation: Gradient.Vertical
            GradientStop { position: 0.0;  color: themeService.darkGradientOuter }
            GradientStop { position: 0.15; color: themeService.darkGradientInner }
            GradientStop { position: 0.85; color: themeService.darkGradientInner }
            GradientStop { position: 1.0;  color: themeService.darkGradientOuter }
        }

        // Clock — ticks every minute, re-evaluates format when use24HourTime changes
        property string currentTime: Qt.formatDateTime(new Date(),
            settingsService.use24HourTime ? "HH:mm" : "h:mm AP")

        Timer {
            interval: 60000; repeat: true; running: true; triggeredOnStart: true
            onTriggered: rectangle.currentTime = Qt.formatDateTime(new Date(),
                settingsService.use24HourTime ? "HH:mm" : "h:mm AP")
        }

        RangerLogo {}

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 24
            anchors.rightMargin: 24

            // ── Left: Time + Outside Temp ──────────────────────────────
            RowLayout {
                Layout.preferredWidth: 200
                spacing: 2

                Text {
                    text: rectangle.currentTime
                    font.family: themeService.fontOxanium
                    font.pixelSize: 28
                    font.weight: Font.Medium
                    color: themeService.foreground
                    Behavior on color { ColorAnimation { duration: themeService.toggleTimer }}
                }

                Text {
                    text: unitsService.displayOutsideTemp <= -999
                        ? "-- " + unitsService.outsideTempUnit
                        : unitsService.displayOutsideTemp.toFixed(1) + " " + unitsService.outsideTempUnit
                    font.family: themeService.fontOxanium
                    font.pixelSize: 14
                    color: themeService.textMuted
                    Behavior on color { ColorAnimation { duration: themeService.toggleTimer }}
                }
            }

            Item { Layout.fillWidth: true }

            // ── Right: Bluetooth + Cell Signal ────────────────────────
            RowLayout {
                Layout.preferredWidth: 200
                Layout.alignment: Qt.AlignRight | Qt.AlignVCenter
                spacing: 16

                Item { Layout.fillWidth: true }

                // Bluetooth icon
                Image {
                    width: 26; height: 26
                    sourceSize.width: 26; sourceSize.height: 26
                    source: themeService.iconPath + "bluetooth-b.svg"
                    fillMode: Image.PreserveAspectFit
                    layer.enabled: true
                    layer.effect: MultiEffect {
                        colorization: 1.0
                        colorizationColor: connectivityService.btConnected
                            ? themeService.info
                            : themeService.muted
                        Behavior on colorizationColor { ColorAnimation { duration: 300 }}
                    }
                }

                // Cell signal — 5 bars of increasing height
                Row {
                    spacing: 3
                    Layout.alignment: Qt.AlignVCenter

                    Repeater {
                        model: 5
                        Rectangle {
                            required property int index
                            width: 5
                            height: 6 + index * 4   // 6, 10, 14, 18, 22 px
                            anchors.bottom: parent.bottom
                            radius: 2
                            color: index < connectivityService.cellSignalBars
                                ? themeService.success
                                : themeService.muted
                            Behavior on color { ColorAnimation { duration: 300 }}
                        }
                    }
                }
            }
        }
    }
}
