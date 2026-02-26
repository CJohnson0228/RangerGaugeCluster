import QtQuick
import QtQuick.Effects
import QtQuick.Layouts
import HMItestUI

ColumnLayout {
    id: root
    property bool leftTurnActive: false
    property bool rightTurnActive: false
    property int activeDataIndex: 0
    property string mediaSourceImage: ""
    property string mediaBandName: ""
    property string mediaSongName: ""

    // Turn indicators & Menu
    RowLayout {
        Layout.topMargin: 5
        Layout.fillWidth: true
        Layout.preferredHeight: 50

        // Left Turn Signal
        TurnSignal {
            Layout.leftMargin: 7
            direction: "left"
            active: root.leftTurnActive
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
            border.color: Theme.darkBorder
            gradient: Gradient {
                GradientStop { position: 0.0; color: Theme.darkGradientInner }
                GradientStop { position: 1.0; color: Theme.darkGradientOuter }
            }
            RowLayout {
                anchors.centerIn: parent
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                spacing: 2

                DataIcon {
                    Layout.preferredWidth: width
                    Layout.alignment: Qt.AlignVCenter
                    active: root.activeDataIndex === 0
                    label: "Truck Data"
                    iconSource: Theme.iconPath + "pickup-truck.svg"
                }

                DataIcon {
                    Layout.preferredWidth: width
                    Layout.alignment: Qt.AlignVCenter
                    active: root.activeDataIndex === 1
                    label: "Music"
                    iconSource: Theme.iconPath + "music.svg"
                }
                DataIcon {
                    Layout.preferredWidth: width
                    Layout.alignment: Qt.AlignVCenter
                    active: root.activeDataIndex === 2
                    label: "Settings"
                    iconSource: Theme.iconPath + "gear.svg"
                }
            }
        }

        // Spacer
        Item { Layout.fillWidth: true }


        // Right Turn Signal
        TurnSignal {
            Layout.rightMargin: 7
            direction: "right"
            active: root.rightTurnActive
        }
    }

    // Media Data Display
    Item {
        Layout.fillHeight: true
        Layout.fillWidth: true

        // Media
        Media{
            mediaSourceImage: root.mediaSourceImage
            mediaBandName: root.mediaBandName
            mediaSongName: root.mediaSongName
        }
    }
}