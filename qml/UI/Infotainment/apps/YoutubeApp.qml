import QtQuick
import QtWebEngine
import HMItestUI

WebAppView {
    url: "https://www.youtube.com"
    profile: youtubeWebProfile
    iconSource: themeService.iconPath + "youtube.svg"
}
