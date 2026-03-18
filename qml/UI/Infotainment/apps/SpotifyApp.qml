import QtQuick
import QtWebEngine
import HMItestUI

WebAppView {
    url: "https://open.spotify.com"
    profile: spotifyWebProfile
    settings.playbackRequiresUserGesture: false
}


