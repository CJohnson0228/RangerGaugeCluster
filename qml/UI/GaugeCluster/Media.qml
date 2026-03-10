// Media Window for InstrumentData display
import QtQuick
import QtQuick.Shapes
import QtQuick.Effects
import QtQuick.Layouts
import HMItestUI

ColumnLayout {
    id: root

    anchors.fill: parent
    spacing: 2
    // Media Image
    Image {
        id: mediaImage
        visible: false
        width: 200
        height: 200
        source: themeService.imagePath + mediaService.sourceImage
        fillMode: Image.PreserveAspectCrop
    }

    Rectangle {
        id: imageMask
        width: 200
        height: 200
        radius: 20
        visible: false
        layer.enabled: true
    }

    MultiEffect {
        Layout.alignment: Qt.AlignHCenter
        width: 200
        height: 200
        source: mediaImage
        maskEnabled: true
        maskSource: imageMask
    }


    // Media Info
    Item {
        Layout.preferredHeight: 60
        Layout.fillWidth: true

        ColumnLayout {
            anchors.fill: parent
            spacing: 2

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: mediaService.trackName
                color: themeService.foreground
                font.pixelSize: 24
                font.family: themeService.fontQuicksand
            }

            Text {
                Layout.alignment: Qt.AlignHCenter
                text: mediaService.artistName
                color: themeService.textMuted
                font.pixelSize: 18
                font.family: themeService.fontQuicksand
            }
        }
    }

    // Media Progress
    Item {
        Layout.alignment: Qt.AlignHCenter

        width: 300
        height: 30

        Text {
            anchors.left: parent.left
            anchors.verticalCenter: progressBar.verticalCenter
            text: "1:42"
            font.family: themeService.fontQuicksand
            font.pixelSize: 11
            color: themeService.textMuted
        }

        Item {
            id: progressBar
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.leftMargin: 36
            anchors.rightMargin: 36
            anchors.verticalCenter: parent.verticalCenter
            height: 4

            Rectangle {
                anchors.fill: parent
                radius: 2
                color: themeService.darkBorder
            }

            Rectangle {
                width: parent.width * 0.4
                height: parent.height
                radius: 2
                color: themeService.primary
                Behavior on width { NumberAnimation { duration: 300; easing.type: Easing.OutCubic }}
            }
        }

        Text {
            anchors.right: parent.right
            anchors.verticalCenter: progressBar.verticalCenter
            text: "4:50"
            font.family: themeService.fontQuicksand
            font.pixelSize: 11
            color: themeService.textMuted
        }
    }

    Item {
        height: 20
    }
}