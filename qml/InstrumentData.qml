import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import HMItestUI

ColumnLayout {
    id: root

    // Turn indicators & Menu
    RowLayout {
        Layout.topMargin: 5
        Layout.fillWidth: true
        Layout.preferredHeight: 50

        // Left Turn Signal
        TurnSignal {
            Layout.leftMargin: 7
            direction: "left"
            active: vehicleState.leftTurnActive
        }

        // Spacer
        Item { Layout.fillWidth: true }

        // Menu
        Rectangle {
            Layout.preferredWidth: 220
            Layout.leftMargin: 40
            Layout.rightMargin: 40
            Layout.preferredHeight: 40
            radius: 20
            border.width: 1
            border.color: themeService.darkBorder
            gradient: Gradient {
                GradientStop { position: 0.0; color: themeService.darkGradientInner }
                GradientStop { position: 1.0; color: themeService.darkGradientOuter }
            }
            RowLayout {
                anchors.centerIn: parent
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                spacing: 2

                DataIcon {
                    Layout.preferredWidth: width
                    Layout.alignment: Qt.AlignVCenter
                    active: vehicleState.activeDataIndex === 0
                    label: "Truck Data"
                    iconSource: themeService.iconPath + "pickup-truck.svg"
                }

                DataIcon {
                    Layout.preferredWidth: width
                    Layout.alignment: Qt.AlignVCenter
                    active: vehicleState.activeDataIndex === 1
                    label: "Music"
                    iconSource: themeService.iconPath + "music.svg"
                }
                DataIcon {
                    Layout.preferredWidth: width
                    Layout.alignment: Qt.AlignVCenter
                    active: vehicleState.activeDataIndex === 2
                    label: "Settings"
                    iconSource: themeService.iconPath + "gear.svg"
                }
            }
        }

        // Spacer
        Item { Layout.fillWidth: true }


        // Right Turn Signal
        TurnSignal {
            Layout.rightMargin: 7
            direction: "right"
            active: vehicleState.rightTurnActive
        }
    }

    // Media & Data Display
    Item {
        Layout.fillHeight: true
        Layout.fillWidth: true

        // VehicleData
        VehicleData {
            opacity: vehicleState.activeDataIndex === 0 ? 1.0 : 0.0
            Behavior on opacity {
                NumberAnimation { duration: themeService.toggleTimer; easing.type: Easing.InOutQuad }
            }
        }

        // Media
        Media{
            opacity: vehicleState.activeDataIndex === 1 ? 1.0 : 0.0
            Behavior on opacity {
                NumberAnimation { duration: themeService.toggleTimer; easing.type: Easing.InOutQuad }
            }
        }

        // Settings
        Settings {
            opacity: vehicleState.activeDataIndex === 2 ? 1.0 : 0.0
            Behavior on opacity {
                NumberAnimation { duration: themeService.toggleTimer; easing.type: Easing.InOutQuad }
            }
        }
    }
}