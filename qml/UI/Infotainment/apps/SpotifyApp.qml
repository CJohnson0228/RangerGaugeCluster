import QtQuick
import QtWebEngine
import HMItestUI

WebAppView {
    url: "https://open.spotify.com"
    profile: spotifyWebProfile
    iconSource: themeService.iconPath + "spotify.svg"
    settings.playbackRequiresUserGesture: false
}


