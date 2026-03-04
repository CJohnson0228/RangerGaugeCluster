// Vehicle Data Window for InstrumentData display
// Settings Window for InstrumentData display
import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import QtQuick.Effects
import HMItestUI

RowLayout {
    id: root

    anchors.fill: parent
    anchors.leftMargin: 20
    anchors.rightMargin: 20
    spacing: 20

    // TPMS
    ColumnLayout {
        Layout.fillHeight: true
        Layout.preferredWidth: 200

        Text {
            Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
            text: "Tire Pressures"
            color: themeService.foreground
            Behavior on color { ColorAnimation { duration: themeService.toggleTimer }}
        }

        Text {
            Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
            text: "PSI"
            color: themeService.textMuted
            Behavior on color { ColorAnimation { duration: themeService.toggleTimer }}
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            Layout.fillHeight: true
            Layout.fillWidth: true

            // Left Tire Pressures
            Item {
                Layout.fillHeight: true
                Layout.preferredWidth: 40

                TirePressReading {
                    id: lfText
                    anchors.top: parent.top
                    anchors.topMargin: 60
                    anchors.horizontalCenter: parent.horizontalCenter

                    tirePress: vehicleState.tirePressLF
                }

                TirePressReading {
                    id: lrText
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 60
                    anchors.horizontalCenter: parent.horizontalCenter
                    tirePress: vehicleState.tirePressLR
                }
            }

            // Truck Image
            Image {
                Layout.preferredWidth: 100
                Layout.preferredHeight: 200
                Layout.alignment: Qt.AlignCenter
                source: themeService.imagePath + "TopView.svg"
                fillMode: Image.PreserveAspectFit
                layer.enabled: true
                layer.effect: MultiEffect {
                    colorization: 1.0
                    colorizationColor: themeService.muted
                    Behavior on colorization { ColorAnimation { duration: themeService.toggleTimer }}
                }
            }

            // Right Tire Pressures
            Item {
                Layout.fillHeight: true
                Layout.preferredWidth: 40

                TirePressReading {
                    id: rfText
                    anchors.top: parent.top
                    anchors.topMargin: 60
                    anchors.horizontalCenter: parent.horizontalCenter

                    tirePress: vehicleState.tirePressRF
                }

                TirePressReading {
                    id: rrText
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 60
                    anchors.horizontalCenter: parent.horizontalCenter

                    tirePress: vehicleState.tirePressRR
                }
            }
        }

        Item {
            Layout.preferredHeight: 50
            Layout.fillWidth: true

            Text {
                anchors.left: parent.left
                text: "Fuel Economy:"
                color: themeService.textMuted
                Behavior on color { ColorAnimation { duration: themeService.toggleTimer }}
            }

            Text {
                anchors.right: parent.right
                text: vehicleState.fuelEconomyAverage.toFixed(2) + " (MPG)"
                color: themeService.foreground
                Behavior on color { ColorAnimation { duration: themeService.toggleTimer }}
            }
        }
    }

    // Data
    ColumnLayout {
        Layout.fillHeight: true
        Layout.fillWidth: true
        Layout.preferredWidth: 100

        Text {
            Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
            text: "Fuel Eco"
            color: themeService.foreground
            Behavior on color { ColorAnimation { duration: themeService.toggleTimer }}
        }

        Item {
            Layout.fillHeight: true
            Layout.topMargin: 20
            Layout.bottomMargin: 60
            Layout.preferredWidth: 60
            Layout.alignment: Qt.AlignHCenter

            // Bar
            Rectangle {
                id: bar
                anchors.right: parent.horizontalCenter
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                border.width: 1
                border.color: themeService.muted
                width: 20
                color: themeService.darkBackground
                Behavior on color { ColorAnimation { duration: themeService.toggleTimer }}
                Behavior on border.color { ColorAnimation { duration: themeService.toggleTimer }}

                Rectangle {
                    anchors.bottom: parent.bottom
                    width: parent.width
                    height: parent.height * (vehicleState.fuelEconomyLive / 30)
                    color: themeService.primary
                }
            }

            // Tick marks and labels
            Repeater {
                model: [
                    { value: 0,  major: true  },
                    { value: 5,  major: false },
                    { value: 10, major: true  },
                    { value: 15, major: false },
                    { value: 20, major: true  },
                    { value: 25, major: false },
                    { value: 30, major: true  }
                ]

                Item {
                    required property var modelData
                    x: bar.x + bar.width
                    y: bar.height - (bar.height * (modelData.value / 30)) + bar.y
                    width: modelData.major ? 10 : 6
                    height: 1

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: themeService.muted
                        opacity: modelData.major ? 1.0 : 0.5
                        Behavior on color { ColorAnimation { duration: themeService.toggleTimer }}
                    }

                    Text {
                        visible: modelData.major
                        anchors.left: parent.right
                        anchors.leftMargin: 3
                        anchors.verticalCenter: parent.verticalCenter
                        text: modelData.value
                        font.family: themeService.fontOxanium
                        font.pixelSize: 10
                        color: themeService.foreground
                        Behavior on color { ColorAnimation { duration: themeService.toggleTimer }}
                    }
                }
            }
        }
    }
}