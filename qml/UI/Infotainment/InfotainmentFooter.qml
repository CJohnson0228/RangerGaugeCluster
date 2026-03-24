import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import HMItestUI

Item {
    id: root
    property string currentApp: ""
    property bool vehicleDataExpanded: false
    signal appTapped(string appId)

    width: parent.width
    height: 80

    RectangularShadow {
        anchors.fill: root
        radius: 3
        color: Qt.rgba(0, 0, 0, 0.7)
        offset.x: 0
        offset.y: -3
        blur: 10
        spread: 3
    }

    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            orientation: Gradient.Vertical
            GradientStop { position: 0.0;  color: themeService.darkBorder }
            GradientStop { position: 0.01; color: themeService.darkGradientOuter }
            GradientStop { position: 0.1;  color: themeService.darkGradientInner }
            GradientStop { position: 1.0;  color: themeService.darkGradientOuter }
        }
    }


    // truck data window toggle button
    FooterButton {
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.verticalCenter: parent.verticalCenter

        appId: "truckData"
        iconSource: "truck_data.svg"
        active: root.vehicleDataExpanded
        onTapped: (id) => root.appTapped(id)
    }

    RowLayout {
        anchors.fill: parent
        spacing: 5

        Item { Layout.fillWidth: true }

        FooterButton {
            appId: "spotify"
            iconSource: "spotify.svg"
            active: root.currentApp === "spotify"
            onTapped: (id) => root.appTapped(id)
        }

        FooterButton {
            appId: "audible"
            iconSource: "audible.svg"
            active: root.currentApp === "audible"
            onTapped: (id) => root.appTapped(id)
        }

        FooterButton {
            appId: "youtube"
            iconSource: "youtube.svg"
            active: root.currentApp === "youtube"
            onTapped: (id) => root.appTapped(id)
        }

        FooterButton {
            appId: "hulu"
            iconSource: "hulu.svg"
            active: root.currentApp === "hulu"
            onTapped: (id) => root.appTapped(id)
        }

        FooterButton {
            appId: "netflix"
            iconSource: "netflix.svg"
            active: root.currentApp === "netflix"
            onTapped: (id) => root.appTapped(id)
        }

        FooterButton {
            appId: "googlemaps"
            iconSource: "maps.svg"
            active: root.currentApp === "googlemaps"
            onTapped: (id) => root.appTapped(id)
        }

        FooterButton {
            appId: "navigation"
            iconSource: "google-maps.svg"
            active: root.currentApp === "navigation"
            onTapped: (id) => root.appTapped(id)
        }

        FooterButton {
            appId: "settings"
            iconSource: "settings.svg"
            active: root.currentApp === "settings"
            onTapped: (id) => root.appTapped(id)
        }

        Item { Layout.fillWidth: true }
    }
}
