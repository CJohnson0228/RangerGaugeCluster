import QtQuick
import QtQuick.Shapes
import QtQuick.Effects
import QtQuick.Layouts
import HMItestUI

ColumnLayout {
    id: root
    property bool leftTurnActive: false
    property bool rightTurnActive: false

    // Turn indicators & Menu
    Rectangle {
        Layout.topMargin: 5
        Layout.fillWidth: true
        Layout.preferredHeight: 50
        color: Theme.darkBackground
        radius: 25

        // Container
        RowLayout {
            anchors.fill: parent

            // Left Turn Signal
            TurnSignal {
                Layout.leftMargin: 7
                direction: "left"
                active: root.leftTurnActive
            }

            // Menu
            Item {
                Layout.fillWidth: true
            }

            // Right Turn Signal
            TurnSignal {
                Layout.rightMargin: 7
                direction: "right"
                active: root.rightTurnActive
            }
        }
    }

    // Media Data Display
    Item {
        Layout.fillHeight: true

        // Media Image

        // Media Info

        // Media Progress

    }
}