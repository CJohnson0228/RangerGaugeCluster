import QtQuick
import QtQuick.Effects
import QtWebEngine
import HMItestUI

Glass {
    anchors.fill: parent

    property url iconSource

    // Expose inner WebEngineView properties so child components can set them directly
    property alias url:       webEngine.url
    property alias profile:   webEngine.profile
    property alias settings:  webEngine.settings
    property alias canGoBack: webEngine.canGoBack

    signal pageLoaded()
    function goBack()              { webEngine.goBack() }
    function runJavaScript(script) { webEngine.runJavaScript(script) }
    // function injectScrollbarFix() {
    //     webEngine.runJavaScript("
    //         var s = document.createElement('style');
    //         s.textContent = '::-webkit-scrollbar { display: none !important; }'
    //                       + '* { scrollbar-width: none !important; -ms-overflow-style: none !important; }';
    //         document.head.appendChild(s);
    //     ")
    // }

    // Clip WebEngineView to the same rounded corners as the Glass mask
    Item {
        id: contentClip
        anchors.fill: parent
        layer.enabled: true
        layer.effect: MultiEffect {
            maskEnabled: true
            maskSource: ShaderEffectSource {
                sourceItem: Rectangle {
                    width: contentClip.width
                    height: contentClip.height
                    radius: 6
                }
            }
            maskThresholdMin: 0.5
            maskSpreadAtMin: 1.0
        }

        Image {
            anchors.centerIn: parent
            width: 192
            height: 192
            source: iconSource
            fillMode: Image.PreserveAspectFit
        }

        WebEngineView {
            id: webEngine
            anchors.fill: parent
            opacity: 0

            backgroundColor: themeService.background

            settings.javascriptEnabled: true
            settings.localStorageEnabled: true
            settings.pluginsEnabled: true
            settings.showScrollBars: false

            onPermissionRequested: function(permission) { permission.grant() }
            onFullScreenRequested: function(request)    { request.accept() }
            onNewWindowRequested:  function(request)    { url = request.requestedUrl }

            onLoadingChanged: function(info) {
                if (info.status === WebEngineLoadingInfo.LoadSucceededStatus) {
                    // injectScrollbarFix()
                    pageLoaded()
                } else if (info.status === WebEngineLoadingInfo.LoadStartedStatus) {
                    fadeIn.stop()
                    fadeDelay.stop()
                    opacity = 0
                }
            }

            onLoadProgressChanged: {
                if (loadProgress === 100)
                    fadeDelay.start()
            }

            Timer {
                id: fadeDelay
                interval: 200
                onTriggered: fadeIn.start()
            }

            NumberAnimation on opacity {
                id: fadeIn
                to: 1.0
                duration: 200
                easing.type: Easing.InOutQuad
            }
        }
    }
}
