import QtQuick
import QtWebEngine
import HMItestUI

WebAppView {
    url: "https://www.netflix.com"
    profile: netflixWebProfile
    settings.playbackRequiresUserGesture: false
}
