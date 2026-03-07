import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import HMItestUI

ApplicationWindow {
    id: root
    visible: true
    width: 400
    height: 900
    title: "Dev Panel"

    Timer {
        id: leftBlinkTimer
        interval: 500
        repeat: true
        onTriggered: vehicleState.leftTurnActive = !vehicleState.leftTurnActive
    }

    Timer {
        id: rightBlinkTimer
        interval: 500
        repeat: true
        onTriggered: vehicleState.rightTurnActive = !vehicleState.rightTurnActive
    }

    GridLayout {
        anchors.fill: parent
        columns: 2
        columnSpacing: 2

        Button {
            Layout.fillWidth: true
            text: "Left Turn"
            onClicked: {
                if (leftBlinkTimer.running) {
                    leftBlinkTimer.stop()
                    vehicleState.leftTurnActive = false
                } else {
                    leftBlinkTimer.start()
                }
            }
        }

        Button {
            Layout.fillWidth: true
            text: "Right Turn"
            onClicked: {
                if (rightBlinkTimer.running) {
                    rightBlinkTimer.stop()
                    vehicleState.rightTurnActive = false
                } else {
                    rightBlinkTimer.start()
                }
            }
        }

        Button {
            Layout.columnSpan: 2
            Layout.fillWidth: true
            text: "Hazards"
            onClicked: {
                if (leftBlinkTimer.running || rightBlinkTimer.running) {
                    leftBlinkTimer.stop()
                    rightBlinkTimer.stop()
                    vehicleState.leftTurnActive = false
                    vehicleState.rightTurnActive = false
                } else {
                    leftBlinkTimer.start()
                    rightBlinkTimer.start()
                }
            }
        }

        Text {
            Layout.columnSpan: 2
            Layout.fillWidth: true
            text: "Gauge Sliders"
            color: "white"
        }

        Slider {
            Layout.alignment: Qt.AlignCenter
            from: 0; to: 120
            value: vehicleState.vehicleSpeed
            onValueChanged: vehicleState.vehicleSpeed = value
        }

        Slider {
            Layout.alignment: Qt.AlignCenter
            from: 0; to: 7000
            value: vehicleState.engineRPM
            onValueChanged: vehicleState.engineRPM = value
        }

        Text {
            Layout.columnSpan: 2
            Layout.fillWidth: true
            text: "Tire Pressures"
            color: "white"
        }

        Slider { Layout.alignment: Qt.AlignCenter; from: 0; to: 50; value: vehicleState.tirePressLF; onValueChanged: vehicleState.tirePressLF = value }
        Slider { Layout.alignment: Qt.AlignCenter; from: 0; to: 50; value: vehicleState.tirePressRF; onValueChanged: vehicleState.tirePressRF = value }
        Slider { Layout.alignment: Qt.AlignCenter; from: 0; to: 50; value: vehicleState.tirePressLR; onValueChanged: vehicleState.tirePressLR = value }
        Slider { Layout.alignment: Qt.AlignCenter; from: 0; to: 50; value: vehicleState.tirePressRR; onValueChanged: vehicleState.tirePressRR = value }

        Button {
            Layout.fillWidth: true
            Layout.columnSpan: 2
            text: "Next General View"
            onClicked: vehicleState.activeDataIndex = (vehicleState.activeDataIndex + 1) % 3
        }

        Button {
            Layout.fillWidth: true
            Layout.columnSpan: 2
            text: "Toggle themeService"
            onClicked: themeService.darkMode = !themeService.darkMode
        }

        Text {
            Layout.columnSpan: 2
            text: "Speed Limit"
            color: "white"
        }
        SpinBox {
            Layout.columnSpan: 2
            Layout.alignment: Qt.AlignHCenter
            from: 0
            to: 90
            stepSize: 5
            value: vehicleState.localSpeedLimit
            onValueChanged: vehicleState.localSpeedLimit = value
        }

        Text { text: "Fuel Eco Current"; color: "white" }
        Slider { Layout.alignment: Qt.AlignCenter; from: 0; to: 30; value: vehicleState.fuelEconomyLive; onValueChanged: vehicleState.fuelEconomyLive = value }
        Text { text: "Fuel Eco Current"; color: "white" }
        Slider { Layout.alignment: Qt.AlignCenter; from: 0; to: 30; value: vehicleState.fuelEconomyAverage; onValueChanged: vehicleState.fuelEconomyAverage = value }

        Button {
            Layout.fillWidth: true
            text: "Battery Warning"
            onClicked: vehicleState.batteryWarningActive = !vehicleState.batteryWarningActive
        }
        Button {
            Layout.fillWidth: true
            text: "Brake Warning"
            onClicked: vehicleState.brakeWarningActive = !vehicleState.brakeWarningActive
        }
        Button {
            Layout.fillWidth: true
            text: "Coolant Temp"
            onClicked: vehicleState.coolantTempWarningActive = !vehicleState.coolantTempWarningActive
        }
        Button {
            Layout.fillWidth: true
            text: "Parking Brake"
            onClicked: vehicleState.parkingBrakeWarningActive = !vehicleState.parkingBrakeWarningActive
        }
        Button {
            Layout.fillWidth: true
            text: "Oil Warning"
            onClicked: vehicleState.oilWarningActive = !vehicleState.oilWarningActive
        }
        Button {
            Layout.fillWidth: true
            text: "Seatbelt"
            onClicked: vehicleState.seatbeltWarningActive = !vehicleState.seatbeltWarningActive
        }
        Button {
            Layout.fillWidth: true
            text: "Check Engine"
            onClicked: vehicleState.checkEngineCautionActive = !vehicleState.checkEngineCautionActive
        }
        Button {
            Layout.fillWidth: true
            text: "Low Fuel"
            onClicked: vehicleState.lowFuelCautionActive = !vehicleState.lowFuelCautionActive
        }
        Button {
            Layout.fillWidth: true
            text: "Tire Pressure"
            onClicked: vehicleState.tirePressCautionActive = !vehicleState.tirePressCautionActive
        }
        Text { Layout.columnSpan: 2; text: "Fuel & Temp"; color: "white" }

        Text { text: "Fuel Gallons"; color: "white" }
        Slider {
            Layout.alignment: Qt.AlignCenter
            from: 0; to: 16.5; stepSize: 0.1
            value: vehicleState.fuelGallonsRemaining
            onValueChanged: vehicleState.fuelGallonsRemaining = value
        }

        Text { text: "Eng Temp °F"; color: "white" }
        Slider {
            Layout.alignment: Qt.AlignCenter
            from: 100; to: 260
            value: vehicleState.engineTemp
            onValueChanged: vehicleState.engineTemp = value
        }
    }
}