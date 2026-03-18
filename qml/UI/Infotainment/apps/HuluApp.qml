import QtQuick
import QtWebEngine
import HMItestUI

WebAppView {
    url: "https://www.hulu.com"
    profile: huluWebProfile
    settings.playbackRequiresUserGesture: false

    // Override to add geolocation spoof alongside scrollbar fix.
    // When real GPS is wired up, swap the hardcoded coords for locationService values.
    onPageLoaded: {
        runJavaScript("
            navigator.geolocation.getCurrentPosition = function(ok) {
                ok({ coords: { latitude: 37.7749, longitude: -122.4194,
                               accuracy: 50, altitude: null, altitudeAccuracy: null,
                               heading: null, speed: null },
                     timestamp: Date.now() });
            };
            navigator.geolocation.watchPosition = function(ok) {
                navigator.geolocation.getCurrentPosition(ok); return 0;
            };
        ")
    }
}
