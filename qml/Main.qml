import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import HMItestUI

ApplicationWindow {
    id: window
    width: 1920
    height: 550
    visible: true
    title: "Ranger HMI"
    color: Theme.background

    // Timer to simulate blinker
    Timer {
        id: leftBlinkTimer
        interval: 500
        repeat: true
        onTriggered: iData.leftTurnActive = !iData.leftTurnActive
    }

    Timer {
        id: rightBlinkTimer
        interval: 500
        repeat: true
        onTriggered: iData.rightTurnActive = !iData.rightTurnActive
    }

    // Temporary mouse click for theme toggle
    MouseArea {
        anchors.fill: parent
        onClicked: Theme.isDarkMode = !Theme.isDarkMode
    }

    Behavior on color { ColorAnimation { duration: Theme.toggleTimer }}

    ColumnLayout {
        anchors.fill: parent

        // Warning Indicators
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 60
            color: Theme.background

            Behavior on color { ColorAnimation { duration: Theme.toggleTimer }}

            RowLayout {
                anchors.fill: parent
                Slider {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    from: 0
                    to: 120
                    value: 0
                    onValueChanged: speedo.value = value
                }

                Button {
                    text: "Left Turn"
                    onClicked: {
                        if (leftBlinkTimer.running) {
                            leftBlinkTimer.stop()
                            iData.leftTurnActive = false
                        } else {
                            leftBlinkTimer.start()
                        }
                    }
                }

                Button {
                    text: "Hazards"
                    onClicked: {
                        if (leftBlinkTimer.running) {
                            leftBlinkTimer.stop()
                            rightBlinkTimer.stop()
                            iData.leftTurnActive = false
                            iData.rightTurnActive = false
                        } else {
                            leftBlinkTimer.start()
                            rightBlinkTimer.start()
                        }
                    }
                }

                Button {
                    text: "Right Turn"
                    onClicked: {
                        if (rightBlinkTimer.running) {
                            rightBlinkTimer.stop()
                            iData.rightTurnActive = false
                        } else {
                            rightBlinkTimer.start()
                        }
                    }
                }

                Slider {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    from: 0
                    to: 7
                    value: 0
                    onValueChanged: tach.value = value
                }
            }


        }

        // Gauges & display
        Item {
            Layout.preferredWidth: 1400
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignHCenter

            Rectangle {
                anchors.centerIn: parent
                width: parent.width - 40
                height: 400
                radius: 200
                gradient: Gradient {
                    orientation: Gradient.Vertical
                    GradientStop {
                        position: 0.0
                        color: Theme.themeGradientOuter
                        Behavior on color { ColorAnimation { duration: Theme.toggleTimer }}
                    }
                    GradientStop {
                        position: 0.25
                        color: Theme.themeGradientInner
                        Behavior on color { ColorAnimation { duration: Theme.toggleTimer }}
                    }
                    GradientStop {
                        position: 0.75
                        color: Theme.themeGradientInner
                        Behavior on color { ColorAnimation { duration: Theme.toggleTimer }}
                    }
                    GradientStop {
                        position: 1.0
                        color: Theme.themeGradientOuter
                        Behavior on color { ColorAnimation { duration: Theme.toggleTimer }}
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
                        Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                        Layout.rightMargin: 8
                    }
                }
            }
        }

        // Data readouts
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 80
            color: Theme.background

            Behavior on color { ColorAnimation { duration: Theme.toggleTimer }}
        }
    }
}