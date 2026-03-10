// Vehicle General Window for InstrumentData display
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
            text: unitsService.tirePressUnit
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
                    tirePress: unitsService.displayTirePressLF
                }

                TirePressReading {
                    id: lrText
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 60
                    anchors.horizontalCenter: parent.horizontalCenter
                    tirePress: unitsService.displayTirePressLR
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
                    tirePress: unitsService.displayTirePressRF
                }

                TirePressReading {
                    id: rrText
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 60
                    anchors.horizontalCenter: parent.horizontalCenter
                    tirePress: unitsService.displayTirePressRR
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
                text: unitsService.displayFuelEconomyAverage.toFixed(2) + " " + unitsService.fuelEconomyUnit
                color: themeService.foreground
                Behavior on color { ColorAnimation { duration: themeService.toggleTimer }}
            }
        }
    }

    // General
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

        Text {
            Layout.alignment: Qt.AlignTop | Qt.AlignHCenter
            text: unitsService.fuelEconomyUnit
            color: themeService.textMuted
            font.pixelSize: 10
            Behavior on color { ColorAnimation { duration: themeService.toggleTimer }}
        }

        Item {
            Layout.fillHeight: true
            Layout.topMargin: 10
            Layout.bottomMargin: 10
            Layout.preferredWidth: 60
            Layout.alignment: Qt.AlignHCenter

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
                    height: parent.height * unitsService.fuelEconomyEfficiency
                    color: themeService.primary
                    Behavior on height { NumberAnimation { duration: 300; easing.type: Easing.OutCubic }}
                }
            }

            Repeater {
                model: [0, 0.333, 0.667, 1.0]
                Item {
                    required property var modelData
                    // Bar is always linear in MPG (0–30). Tick position = modelData * 30 mpg.
                    // Imperial: show the MPG value directly.
                    // Metric: convert the MPG position to its L/100km equivalent.
                    //         Bottom tick (0 mpg) = stopped, shown as "--".
                    property string tickLabel: settingsService.metricUnits
                        ? (modelData > 0 ? Math.round(235.214 / (modelData * 30.0)).toString() : "--")
                        : Math.round(modelData * 30.0).toString()
                    x: bar.x + bar.width
                    y: bar.height - (bar.height * modelData) + bar.y
                    width: 10
                    height: 1

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: themeService.muted
                        Behavior on color { ColorAnimation { duration: themeService.toggleTimer }}
                    }

                    Text {
                        anchors.left: parent.right
                        anchors.leftMargin: 3
                        anchors.verticalCenter: parent.verticalCenter
                        text: parent.tickLabel
                        font.family: themeService.fontOxanium
                        font.pixelSize: 10
                        color: themeService.foreground
                        Behavior on color { ColorAnimation { duration: themeService.toggleTimer }}
                    }
                }
            }
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            Layout.bottomMargin: 4
            text: vehicleState.fuelEconomyLive <= 0
                ? "--"
                : unitsService.displayFuelEconomyLive.toFixed(1) + " " + unitsService.fuelEconomyUnit
            font.family: themeService.fontOxanium
            font.pixelSize: 14
            color: themeService.foreground
            Behavior on color { ColorAnimation { duration: themeService.toggleTimer }}
        }
    }
}