import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import HMItestUI

ApplicationWindow {
    id: window
    width: 1920
    height: 550
    visible: true
    title: "Ranger Gauge Cluster"
    color: themeService.background
    Behavior on color { ColorAnimation { duration: themeService.toggleTimer }}

    // Image Background
    AmbientBackground {
        id: ambientBackground
        Component.onCompleted: themeService.backgroundItem = ambientBackground
    }

    ColumnLayout {
        anchors.fill: parent

        // Warning Indicators
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            color: themeService.darkBackground

            WarningIndicators {}
        }

        // Gauges & display
        Item {
            Layout.preferredWidth: 1250
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignHCenter
            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: themeService.darkBackground
                Behavior on shadowColor { ColorAnimation { duration: 200 }}
                shadowScale: 1.0
                shadowVerticalOffset: 2
                shadowHorizontalOffset: 1
                shadowBlur: 0.6
                shadowOpacity: 0.8
            }

            Rectangle {
                anchors.centerIn: parent
                width: parent.width - 40
                height: 400
                radius: 200
                gradient: Gradient {
                    orientation: Gradient.Vertical
                    GradientStop {
                        position: 0.0
                        color: themeService.gradientOuter
                        Behavior on color { ColorAnimation { duration: themeService.toggleTimer }}
                    }
                    GradientStop {
                        position: 0.25
                        color: themeService.gradientInner
                        Behavior on color { ColorAnimation { duration: themeService.toggleTimer }}
                    }
                    GradientStop {
                        position: 0.75
                        color: themeService.gradientInner
                        Behavior on color { ColorAnimation { duration: themeService.toggleTimer }}
                    }
                    GradientStop {
                        position: 1.0
                        color: themeService.gradientOuter
                        Behavior on color { ColorAnimation { duration: themeService.toggleTimer }}
                    }
                }

                RowLayout {
                    anchors.fill: parent

                    Speedo {
                        id: speedo
                        Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                        Layout.leftMargin: 8
                    }

                    InstrumentData {
                        id: iData
                        Layout.fillWidth: true
                    }

                    Tach {
                        id: tach
                        value: ( vehicleState.engineRPM / 1000 )
                        Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                        Layout.rightMargin: 8
                    }
                }
            }
        }

        // General readouts
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            color: themeService.darkBackground

            GeneralReadouts {}
        }
    }
}