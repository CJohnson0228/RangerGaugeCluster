import QtQuick
import QtWebEngine
import HMItestUI

WebAppView {
    url: "https://maps.google.com"
    profile: navigationWebProfile
    settings.javascriptCanAccessClipboard: true
}
