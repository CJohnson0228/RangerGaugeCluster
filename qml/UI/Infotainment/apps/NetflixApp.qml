import QtQuick
import QtWebEngine
import HMItestUI

WebAppView {
    url: "https://www.netflix.com"
    profile: netflixWebProfile
    iconSource: themeService.iconPath + "netflix.svg"
    settings.playbackRequiresUserGesture: false
}
