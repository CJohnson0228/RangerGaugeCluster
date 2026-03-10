import QtQuick
import QtQuick.Layouts
import HMItestUI

RowLayout {
    anchors.centerIn: parent
    spacing: 20

    // Fuel Indicator
    RowLayout {
        spacing: 40

        ColumnLayout {
            spacing: 2
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "FUEL"
                font.family: themeService.fontOxanium
                font.pixelSize: 10
                color: themeService.darkTextMuted
            }

            Rectangle {
                id: fuelGauge
                width: 200
                height: 24
                color: "transparent"

                // Bar Track
                Rectangle {
                    anchors.bottom: fuelGauge.bottom
                    width: fuelGauge.width
                    height: 10
                    color: themeService.darkMuted

                    Rectangle {
                        id: fuelBar
                        property real level: vehicleState.fuelLevel
                        width: parent.width * level
                        height: parent.height
                        color: Qt.hsla((level * 0.33), 0.85, 0.45, 1.0)
                        Behavior on width { NumberAnimation { duration: 500; easing.type: Easing.OutCubic }}
                        Behavior on color { ColorAnimation { duration: 500 }}
                    }
                }

                // Tickmarks
                Repeater {
                    model: 9
                    Rectangle {
                        property bool isMajor: index % 2 === 0
                        width: isMajor ? 2 : 1
                        height: isMajor ? 6 : 3
                        x: (index / 8) * fuelGauge.width - width / 2
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 10
                        color: themeService.darkTextMuted
                    }
                }
            }
        }

        // Range
        ColumnLayout {
            spacing: 8
            width: 100
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "Range"
                font.family: themeService.fontOxanium
                font.pixelSize: 11
                color: themeService.darkTextMuted
            }
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: unitsService.displayFuelRange.toFixed(1) + " " + unitsService.distanceUnit
                font.family: themeService.fontOxanium
                font.pixelSize: 16
                color: themeService.darkForeground
            }
        }
    }

    // Odometer
    ColumnLayout {
        Layout.leftMargin: 40
        Layout.rightMargin: 40
        spacing: 4

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: "ODOMETER"
            font.family: themeService.fontOxanium
            font.pixelSize: 11
            color: themeService.darkTextMuted
        }

        Text {
            Layout.alignment: Qt.AlignHCenter
            text: unitsService.displayOdometer.toLocaleString(Qt.locale(), 'f', 0) + " " + unitsService.distanceUnit
            font.family: themeService.fontOxanium
            font.pixelSize: 20
            color: themeService.darkForeground
        }
    }

    // Engine Temp Indicator
    RowLayout {
        spacing: 40


        ColumnLayout {
            spacing: 8
            width: 100
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "Engine Temp"
                font.family: themeService.fontOxanium
                font.pixelSize: 11
                color: themeService.darkTextMuted
            }
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: unitsService.displayEngineTemp.toFixed(1) + " " + unitsService.tempUnit
                font.family: themeService.fontOxanium
                font.pixelSize: 16
                color: themeService.darkForeground
            }
        }

        ColumnLayout {
            spacing: 2
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "TEMP"
                font.family: themeService.fontOxanium
                font.pixelSize: 10
                color: themeService.darkTextMuted
            }

            Rectangle {
                id: tempGauge
                width: 200
                height: 24
                color: "transparent"

                // Bar Track
                Rectangle {
                    anchors.bottom: tempGauge.bottom
                    width: tempGauge.width
                    height: 10
                    color: themeService.darkMuted

                    Rectangle {
                        id: tempBar
                        // Normalize raw °C against the operating range (70–110°C)
                        // Bar is hidden below 75°C — engine not yet up to temp
                        property real rawTemp: vehicleState.engineTemp
                        property real level: Math.max(0.0, Math.min(1.0, (rawTemp - 70.0) / (110.0 - 70.0)))
                        property bool atTemp: rawTemp >= 75.0

                        width: atTemp ? parent.width * level : 0
                        height: parent.height
                        color: Qt.hsla((1.0 - level) * 0.33, 0.85, 0.45, 1.0)
                        opacity: atTemp ? 1.0 : 0.0
                        Behavior on width { NumberAnimation { duration: 500; easing.type: Easing.OutCubic }}
                        Behavior on color { ColorAnimation { duration: 500 }}
                        Behavior on opacity { NumberAnimation { duration: 1000 }}
                    }
                }

                // Tickmarks
                Repeater {
                    model: 9
                    Rectangle {
                        property bool isMajor: index % 2 === 0
                        width: isMajor ? 2 : 1
                        height: isMajor ? 6 : 3
                        x: (index / 8) * tempGauge.width - width / 2
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 10
                        color: themeService.darkTextMuted
                    }
                }
            }
        }
    }
}