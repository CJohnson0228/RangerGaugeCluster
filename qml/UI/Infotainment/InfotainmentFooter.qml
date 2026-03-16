import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import HMItestUI

Item {
    id: root
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
        id: rectangle
        anchors.fill: parent
        gradient: Gradient {
            orientation: Gradient.Vertical
            GradientStop { position: 0.0;  color: themeService.darkBorder }
            GradientStop { position: 0.01;  color: themeService.darkGradientOuter }
            GradientStop { position: 0.1; color: themeService.darkGradientInner }
            GradientStop { position: 1.0;  color: themeService.darkGradientOuter }
        }
    }

    RowLayout {
        anchors.fill: parent
        spacing: 5

        Item { Layout.fillWidth: true }

        // Spotify
        FooterButton {
            iconSource: "spotify.svg"
        }

        // Youtube
        FooterButton {
            iconSource: "youtube.svg"
        }

        // Hulu
        FooterButton {
            iconSource: "hulu.svg"
        }

        // Metflix
        FooterButton {
            iconSource: "netflix.svg"
        }

        // Navigation
        FooterButton {
            iconSource: "google-maps.svg"
        }

        // Settings
        FooterButton {
            iconSource: "settings.svg"
        }

        Item { Layout.fillWidth: true }
    }
}