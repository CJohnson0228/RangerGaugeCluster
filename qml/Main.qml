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
    title: "Ranger HMI"
    color: Theme.background
    Behavior on color { ColorAnimation { duration: Theme.toggleTimer }}

    // Dev Properties
    property bool devOpen: false


    // Dev - Timer to simulate blinker
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

    // Dev - Controls Toggle
    Button {
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        height: 40
        width: 40
        z: 1
        onClicked: window.devOpen = !window.devOpen

        background: Rectangle {
            color: Theme.paper
            radius: 20
        }

        contentItem: Image {
            source: Theme.iconPath + "exclamation-circle.svg"
            sourceSize.width: width
            sourceSize.height: height
            layer.enabled: true
            layer.effect: MultiEffect {
                colorization: 1.0
                colorizationColor: Theme.foreground
            }
        }
    }

    // Dev Window
    DevPanel {
        open: devOpen
        leftBlinkerTimerProp: leftBlinkTimer
        rightBlinkerTimerProp: rightBlinkTimer
        iDataProp: iData
        speedoProp: speedo
        tacho: tach
    }


    // Image Background
    AmbientBackground {
        id: ambientBackground
        Component.onCompleted: Theme.backgroundItem = ambientBackground
    }

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
            }
        }

        // Gauges & display
        Item {
            Layout.preferredWidth: 1400
            Layout.fillHeight: true
            Layout.alignment: Qt.AlignHCenter
            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowColor: Theme.darkBackground
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
                        value: 0
                        Layout.alignment: Qt.AlignVCenter | Qt.AlignHCenter
                        Layout.leftMargin: 8
                    }

                    InstrumentData {
                        id: iData
                        Layout.fillWidth: true
                        mediaSourceImage: "tool.jpg"
                        mediaBandName: "Tool"
                        mediaSongName: "Sober"
                    }

                    Tach {
                        id: tach
                        value: 0
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