import QtQuick
import QtWebEngine
import HMItestUI

WebAppView {
    url: "https://maps.google.com"
    profile: navigationWebProfile
    iconSource: themeService.iconPath + "maps.svg"
    settings.javascriptCanAccessClipboard: true
}
