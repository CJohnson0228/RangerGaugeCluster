import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import HMItestUI

Glass {
    id: root
    Layout.fillWidth: true
    Layout.preferredHeight: 500
    Layout.leftMargin: 20
    Layout.rightMargin: 20

    Text {
        anchors.centerIn: parent
        text: "Vehicle Data Panel"
        color: themeService.foreground
    }
}