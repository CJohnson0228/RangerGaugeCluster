// DevPanel.qml
// DEV-ONLY TESTING PANEL - Remove Loader in main.qml for production
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import HMItestUI

Item {
    id: root
    property var leftBlinkerTimerProp
    property var rightBlinkerTimerProp
    property var iDataProp
    property var speedoProp
    property var tacho
    property bool open: false
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    width: 300
    z: 1

    Rectangle {
        anchors.fill: parent
        visible: root.open
        color: Theme.background

        GridLayout {
            anchors.fill: parent
            columns: 2
            columnSpacing: 2

            // Left Turn Simulator
            Button {
                Layout.fillWidth: true
                text: "Left Turn"
                onClicked: {
                    if (leftBlinkerTimerProp.running) {
                        leftBlinkerTimerProp.stop()
                        iDataProp.leftTurnActive = false
                    } else {
                        leftBlinkerTimerProp.start()
                    }
                }
            }

            // Right Turn Simulator
            Button {
                Layout.fillWidth: true
                text: "Right Turn"
                onClicked: {
                    if (rightBlinkerTimerProp.running) {
                        rightBlinkerTimerProp.stop()
                        iDataProp.rightTurnActive = false
                    } else {
                        rightBlinkerTimerProp.start()
                    }
                }
            }

            // Hazard Simulator
            Button {
                Layout.columnSpan: 2
                Layout.fillWidth: true
                text: "Hazards"
                onClicked: {
                    if (leftBlinkerTimerProp.running) {
                        leftBlinkerTimerProp.stop()
                        rightBlinkerTimerProp.stop()
                        iDataProp.leftTurnActive = false
                        iDataProp.rightTurnActive = false
                    } else {
                        leftBlinkerTimerProp.start()
                        rightBlinkerTimerProp.start()
                    }
                }
            }

            // Speedo Simulator
            Slider {
                orientation: Qt.Vertical
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredHeight: 100
                from: 0
                to: 120
                value: 0
                onValueChanged: speedoProp.value = value
            }

            // Tacho Simulator
            Slider {
                orientation: Qt.Vertical
                Layout.fillHeight: true
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredHeight: 100
                from: 0
                to: 7
                value: 0
                onValueChanged: tacho.value = value
            }

            // Data Selection Simulator
            Button {
                Layout.fillWidth: true
                Layout.columnSpan: 2
                text: "Data click"
                onClicked: iDataProp.activeDataIndex = (iDataProp.activeDataIndex + 1) % 3
            }

            // Theme Toggle
            Button {
                Layout.fillWidth: true
                Layout.columnSpan: 2
                text: "Theme Toggle"
                onClicked: Theme.isDarkMode = !Theme.isDarkMode
            }
        }
    }


}