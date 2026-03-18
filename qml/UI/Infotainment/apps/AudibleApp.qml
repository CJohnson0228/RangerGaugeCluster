import QtQuick
import QtWebEngine
import HMItestUI

Item {
    anchors.fill: parent

    WebAppView {
        id: webView
        anchors.fill: parent
        url: "https://www.audible.com"
        profile: audibleWebProfile
        iconSource: themeService.iconPath + "audible.svg"
    }

    Rectangle {
        visible: webView.canGoBack
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.margins: 16
        width: 56
        height: 56
        radius: 28
        color: themeService.card
        opacity: 0.9

        Text {
            anchors.centerIn: parent
            text: "‹"
            font.pixelSize: 32
            color: themeService.foreground
        }

        MouseArea {
            anchors.fill: parent
            onClicked: webView.goBack()
        }
    }
}
