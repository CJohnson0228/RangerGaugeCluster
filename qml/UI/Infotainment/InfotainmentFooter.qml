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
        border.color: themeService.darkBorder
        border.width: 1
        gradient: Gradient {
            orientation: Gradient.Vertical
            GradientStop { position: 0.0;  color: themeService.darkGradientOuter }
            GradientStop { position: 0.15; color: themeService.darkGradientInner }
            GradientStop { position: 0.85; color: themeService.darkGradientInner }
            GradientStop { position: 1.0;  color: themeService.darkGradientOuter }
        }
    }

    RowLayout {
        spacing: 2

        // get better svg icons for apps

        // Spotify
        FooterButton {
            iconColor: "#1db954"
            iconSource: "spotify.svg"
        }

        // Youtube
        FooterButton {
            iconColor: "#ff0000"
            iconSource: "youtube.svg"
        }

        // Navigation
        FooterButton {
            iconSource: "map-marked-alt.svg"
        }

        // Settings
        FooterButton {
            iconSource: "cog.svg"
        }
    }
}