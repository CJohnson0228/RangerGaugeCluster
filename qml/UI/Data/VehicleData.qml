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
            color: Theme.foreground
            Behavior on color { ColorAnimation { duration: Theme.toggleTimer }}
        }

        Text {
            Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
            text: "PSI"
            color: Theme.textMuted
            Behavior on color { ColorAnimation { duration: Theme.toggleTimer }}
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

                    tirePress: VehicleState.tirePressLF
                }

                TirePressReading {
                    id: lrText
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 60
                    anchors.horizontalCenter: parent.horizontalCenter
                    tirePress: VehicleState.tirePressLR
                }
            }

            // Truck Image
            Image {
                Layout.preferredWidth: 100
                Layout.preferredHeight: 200
                Layout.alignment: Qt.AlignCenter
                source: Theme.imagePath + "TopView.svg"
                fillMode: Image.PreserveAspectFit
                layer.enabled: true
                layer.effect: MultiEffect {
                    colorization: 1.0
                    colorizationColor: Theme.muted
                    Behavior on colorization { ColorAnimation { duration: Theme.toggleTimer }}
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

                    tirePress: VehicleState.tirePressRF
                }

                TirePressReading {
                    id: rrText
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 60
                    anchors.horizontalCenter: parent.horizontalCenter

                    tirePress: VehicleState.tirePressRR
                }
            }
        }

        Item {
            Layout.preferredHeight: 50
            Layout.fillWidth: true

            Text {
                anchors.left: parent.left
                text: "Fuel Economy:"
                color: Theme.textMuted
                Behavior on color { ColorAnimation { duration: Theme.toggleTimer }}
            }

            Text {
                anchors.right: parent.right
                text: VehicleState.fuelEconomyAverage.toFixed(2) + " (MPG)"
                color: Theme.foreground
                Behavior on color { ColorAnimation { duration: Theme.toggleTimer }}
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
            color: Theme.foreground
            Behavior on color { ColorAnimation { duration: Theme.toggleTimer }}
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
                border.color: Theme.muted
                width: 20
                color: Theme.darkBackground
                Behavior on color { ColorAnimation { duration: Theme.toggleTimer }}
                Behavior on border.color { ColorAnimation { duration: Theme.toggleTimer }}

                Rectangle {
                    anchors.bottom: parent.bottom
                    width: parent.width
                    height: parent.height * (VehicleState.fuelEconomyLive / 30)
                    color: Theme.primary
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
                        color: Theme.muted
                        opacity: modelData.major ? 1.0 : 0.5
                        Behavior on color { ColorAnimation { duration: Theme.toggleTimer }}
                    }

                    Text {
                        visible: modelData.major
                        anchors.left: parent.right
                        anchors.leftMargin: 3
                        anchors.verticalCenter: parent.verticalCenter
                        text: modelData.value
                        font.family: Theme.fontOxanium
                        font.pixelSize: 10
                        color: Theme.foreground
                        Behavior on color { ColorAnimation { duration: Theme.toggleTimer }}
                    }
                }
            }
        }
    }
}