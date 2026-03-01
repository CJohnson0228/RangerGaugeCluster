// DevPanel.qml
// DEV-ONLY TESTING PANEL - Remove Loader in main.qml for production
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import HMItestUI

Window {
    id: root
    property var leftBlinkerTimer
    property var rightBlinkerTimer
    visible: false
    x: 0
    y: 0
    width: 400
    height: 800


    // Dev - Timer to simulate blinker
    Timer {
        id: leftBlinkTimer
        interval: 500
        repeat: true
        onTriggered: VehicleState.leftTurnActive = !VehicleState.leftTurnActive
    }

    Timer {
        id: rightBlinkTimer
        interval: 500
        repeat: true
        onTriggered: VehicleState.rightTurnActive = !VehicleState.rightTurnActive
    }

    GridLayout {
        anchors.fill: parent
        columns: 2
        columnSpacing: 2

        // Left Turn Simulator
        Button {
            Layout.fillWidth: true
            text: "Left Turn"
            onClicked: {
                if (leftBlinkerTimer.running) {
                    leftBlinkerTimer.stop()
                    VehicleState.leftTurnActive = false
                } else {
                    leftBlinkerTimer.start()
                }
            }
        }

        // Right Turn Simulator
        Button {
            Layout.fillWidth: true
            text: "Right Turn"
            onClicked: {
                if (rightBlinkerTimer.running) {
                    rightBlinkerTimer.stop()
                    VehicleState.rightTurnActive = false
                } else {
                    rightBlinkerTimer.start()
                }
            }
        }

        // Hazard Simulator
        Button {
            Layout.columnSpan: 2
            Layout.fillWidth: true
            text: "Hazards"
            onClicked: {
                if (leftBlinkerTimer.running || rightBlinkerTimer.running) {
                    leftBlinkerTimer.stop()
                    rightBlinkerTimer.stop()
                    VehicleState.leftTurnActive = false
                    VehicleState.rightTurnActive = false
                } else {
                    leftBlinkerTimer.start()
                    rightBlinkerTimer.start()
                }
            }
        }

        Text {
            Layout.columnSpan: 2
            Layout.fillWidth: true
            text: "Gauge Sliders"
            color: Theme.foreground
        }

        // Speedo Simulator
        Slider {
            Layout.alignment: Qt.AlignCenter
            from: 0
            to: 120
            value: VehicleState.vehicleSpeed
            onValueChanged: VehicleState.vehicleSpeed = value
        }

        // Tacho Simulator
        Slider {
            Layout.alignment: Qt.AlignCenter
            from: 0
            to: 7
            value: VehicleState.engineRPM
            onValueChanged: VehicleState.engineRPM = value
        }


        Text {
            Layout.columnSpan: 2
            Layout.fillWidth: true
            text: "Tire Sliders"
            color: Theme.foreground
        }
        // lF Simulator
        Slider {
            Layout.alignment: Qt.AlignCenter
            from: 0
            to: 50
            value: VehicleState.tirePressLF
            onValueChanged: VehicleState.tirePressLF = value
        }
        // RF Simulator
        Slider {
            Layout.alignment: Qt.AlignCenter
            from: 0
            to: 50
            value: VehicleState.tirePressRF
            onValueChanged: VehicleState.tirePressRF = value
        }
        // LR Simulator
        Slider {
            Layout.alignment: Qt.AlignCenter
            from: 0
            to: 50
            value: VehicleState.tirePressLR
            onValueChanged: VehicleState.tirePressLR = value
        }
        // RR Simulator
        Slider {
            Layout.alignment: Qt.AlignCenter
            from: 0
            to: 50
            value: VehicleState.tirePressRR
            onValueChanged: VehicleState.tirePressRR = value
        }

        // Data Selection Simulator
        Button {
            Layout.fillWidth: true
            Layout.columnSpan: 2
            text: "Data click"
            onClicked: VehicleState.activeDataIndex = (VehicleState.activeDataIndex + 1) % 3
        }

        // Theme Toggle
        Button {
            Layout.fillWidth: true
            Layout.columnSpan: 2
            text: "Theme Toggle"
            onClicked: Theme.isDarkMode = !Theme.isDarkMode
        }

        // live fuel eco Simulator
        Slider {
            Layout.alignment: Qt.AlignCenter
            from: 0
            to: 30
            value: VehicleState.fuelEconomyLive
            onValueChanged: VehicleState.fuelEconomyLive = value
        }
        // Average fuel eco Simulator
        Slider {
            Layout.alignment: Qt.AlignCenter
            from: 0
            to: 30
            value: VehicleState.fuelEconomyAverage
            onValueChanged: VehicleState.fuelEconomyAverage = value
        }
    }
}