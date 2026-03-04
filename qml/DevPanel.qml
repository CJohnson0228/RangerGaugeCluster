import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import HMItestUI

ApplicationWindow {
    id: root
    visible: true
    x: 0
    y: 0
    width: 400
    height: 800
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
            text: "Next Data View"
            onClicked: vehicleState.activeDataIndex = (vehicleState.activeDataIndex + 1) % 3
        }

        Button {
            Layout.fillWidth: true
            Layout.columnSpan: 2
            text: "Toggle themeService"
            onClicked: themeService.darkMode = !themeService.darkMode
        }

        Slider { Layout.alignment: Qt.AlignCenter; from: 0; to: 30; value: vehicleState.fuelEconomyLive; onValueChanged: vehicleState.fuelEconomyLive = value }
        Slider { Layout.alignment: Qt.AlignCenter; from: 0; to: 30; value: vehicleState.fuelEconomyAverage; onValueChanged: vehicleState.fuelEconomyAverage = value }
    }
}