import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import HMItestUI

Glass {
    id: root
    property bool expanded: false

    Layout.fillWidth: true
    Layout.preferredHeight: panelHeight
    Layout.leftMargin: 20
    Layout.rightMargin: 20

    property real panelHeight: expanded ? 500 : 100
    Behavior on panelHeight {
        NumberAnimation { duration: 260; easing.type: Easing.OutCubic }
    }

    Text {
        anchors.centerIn: parent
        text: "Vehicle Data Panel"
        color: themeService.foreground
    }
}