import QtQuick
import QtWebEngine

Item {
    id: root

    // Set your Mapbox access token here (or pass it in from C++/parent)
    property string mapboxAccessToken: ""

    // Vehicle position — update these from your location provider
    property real vehicleLat: 33.7783
    property real vehicleLon: -117.9989
    property real vehicleHeading: 0

    // Destination
    property real destLat: 33.7745
    property real destLon: -117.9377

    // Internal flag — wait for the map JS to finish loading before calling into it
    property bool mapReady: false

    Component.onCompleted: {
        if (mapboxAccessToken.length === 0)
            console.warn("mapboxAccessToken is not set")
    }

    // --- Public functions to drive the map ---

    function updateVehicle() {
        if (!mapReady) return
        mapView.runJavaScript("updateVehicle(%1, %2, %3)".arg(vehicleLat).arg(vehicleLon).arg(vehicleHeading))
    }

    function centerOnVehicle() {
        if (!mapReady) return
        mapView.runJavaScript("centerOnVehicle(%1, %2, 0, null)".arg(vehicleLat).arg(vehicleLon))
    }

    function updateDestination() {
        if (!mapReady) return
        mapView.runJavaScript("updateDestination(%1, %2)".arg(destLat).arg(destLon))
    }

    // Pass a GeoJSON coordinate array (array of [lon, lat] pairs)
    function updateRoute(coordinates) {
        if (!mapReady) return
        mapView.runJavaScript("updateRoute(" + JSON.stringify(coordinates) + ")")
    }

    function setMapStyle(styleName) {
        if (!mapReady) return
        // styleName: "street" | "dark" | "satellite"
        mapView.runJavaScript("setMapStyle('" + styleName + "')")
    }

    // --- WebEngineView loading mapbox.html ---

    WebEngineView {
        id: mapView
        anchors.fill: parent
        url: Qt.resolvedUrl("mapbox.html")

        onLoadingChanged: function(loadRequest) {
            if (loadRequest.status === WebEngineView.LoadSucceededStatus) {
                mapView.runJavaScript("initMap('" + mapboxAccessToken + "')")
                mapInitTimer.start()
            }
        }

        // Small delay to let the Mapbox GL map finish its own async initialization
        Timer {
            id: mapInitTimer
            interval: 1000
            onTriggered: {
                mapReady = true
                root.updateVehicle()
                root.updateDestination()
                root.centerOnVehicle()
            }
        }
    }
}
