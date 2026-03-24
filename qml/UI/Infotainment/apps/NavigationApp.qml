import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import QtWebEngine
import HMItestUI

Item {
    id: root
    anchors.fill: parent
    clip: true

    // ── Map state ─────────────────────────────────────────────────────────────
    property bool mapReady: false

    // ── JS bridge helpers ─────────────────────────────────────────────────────
    function jsUpdateVehicle() {
        if (!mapReady) return
        mapView.runJavaScript(
            "updateVehicle(%1, %2, %3)".arg(locationService.latitude)
                                        .arg(locationService.longitude)
                                        .arg(locationService.heading))
    }

    function jsCenterOnVehicle() {
        if (!mapReady) return
        var bearing = navigationService.isNavigating ? locationService.heading    : "null"
        var pitch   = navigationService.isNavigating ? navigationService.navPitch : "null"
        var zoom    = navigationService.isNavigating ? navigationService.navZoom  : "null"
        mapView.runJavaScript(
            "centerOnVehicle(%1, %2, %3, %4, %5)".arg(locationService.latitude)
                                                   .arg(locationService.longitude)
                                                   .arg(bearing).arg(pitch).arg(zoom))
    }

    function jsUpdateRoute() {
        if (!mapReady) return
        var raw = navigationService.routePath
        var coords = []
        for (var i = 0; i < raw.length; i++)
            coords.push([raw[i].longitude, raw[i].latitude])
        mapView.runJavaScript("updateRoute(" + JSON.stringify(coords) + ")")
    }

    // Arrow glyph from maneuver type + modifier
    function stepIcon(type, modifier) {
        if (type === "arrive")  return "⬤"
        if (type === "depart")  return "↑"
        if (type === "merge")   return "↑"
        if (type === "fork" || type === "off ramp" || type === "on ramp") {
            if (modifier.includes("right")) return "↗"
            if (modifier.includes("left"))  return "↖"
            return "↑"
        }
        if (modifier === "uturn")        return "↶"
        if (modifier === "sharp left")   return "↰"
        if (modifier === "left")         return "←"
        if (modifier === "slight left")  return "↖"
        if (modifier === "straight")     return "↑"
        if (modifier === "slight right") return "↗"
        if (modifier === "right")        return "→"
        if (modifier === "sharp right")  return "↱"
        return "↑"
    }

    // ── WebEngineView ─────────────────────────────────────────────────────────
    WebEngineView {
        id: mapView
        anchors.fill: parent
        profile: navigationWebProfile
        url: "qrc:/qt/qml/HMItestUI/resources/html/mapbox.html"
        settings.localContentCanAccessRemoteUrls: true
        settings.localStorageEnabled: true
        onLoadingChanged: function(req) {
            if (req.status === WebEngineView.LoadSucceededStatus)
                mapInitTimer.start()
        }
    }

    Timer {
        id: mapInitTimer; interval: 1200
        onTriggered: {
            mapView.runJavaScript("initMap('" + navigationService.accessToken + "')")
            mapReadyTimer.start()
        }
    }
    Timer {
        id: mapReadyTimer; interval: 1500
        onTriggered: { mapReady = true; jsUpdateVehicle(); jsCenterOnVehicle() }
    }

    // ── GPS follow ────────────────────────────────────────────────────────────
    Connections {
        target: locationService
        function onLatitudeChanged()  { jsUpdateVehicle(); if (navigationService.isNavigating) jsCenterOnVehicle() }
        function onLongitudeChanged() { jsUpdateVehicle(); if (navigationService.isNavigating) jsCenterOnVehicle() }
        function onHeadingChanged()   { jsUpdateVehicle(); if (navigationService.isNavigating) jsCenterOnVehicle() }
    }

    // ── Navigation service reactions ──────────────────────────────────────────
    Connections {
        target: navigationService

        function onRoutePathChanged() { jsUpdateRoute() }

        function onRouteReady() {
            if (!mapReady) return
            var raw = navigationService.routePath
            if (raw.length === 0) return
            var mid  = raw[Math.floor(raw.length / 2)]
            var last = raw[raw.length - 1]
            mapView.runJavaScript("showRouteOverview(%1, %2)".arg(mid.latitude).arg(mid.longitude))
            mapView.runJavaScript("setDestination(%1, %2)".arg(last.latitude).arg(last.longitude))
            directionsPanel.open()
        }

        function onIsNavigatingChanged() {
            if (!mapReady) return
            mapView.runJavaScript("setNavigating(" + (navigationService.isNavigating ? "true" : "false") + ")")
            if (navigationService.isNavigating) {
                directionsPanel.close()
                jsCenterOnVehicle()
            } else {
                mapView.runJavaScript("updateRoute([])")
                mapView.runJavaScript("setDestination(0,0)")
            }
        }
    }

    // Live camera tuning from DevPanel sliders
    Connections {
        target: navigationService
        function onNavPitchChanged() {
            if (mapReady) mapView.runJavaScript("map.easeTo({pitch:" + navigationService.navPitch + ",duration:200})")
        }
        function onNavZoomChanged() {
            if (mapReady) mapView.runJavaScript("map.easeTo({zoom:" + navigationService.navZoom + ",duration:200})")
        }
    }

    // ── Search bar (visible when not navigating and panel not open) ───────────
    Rectangle {
        id: searchBar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: 14
        anchors.topMargin: 16
        height: 58
        radius: 12
        color: Qt.rgba(themeService.card.r, themeService.card.g, themeService.card.b, 0.96)
        visible: !navigationService.isNavigating

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 14; anchors.rightMargin: 10
            spacing: 8

            // original text based icon
            // Text { text: "⌕"; font.pixelSize: 22; color: themeService.textMuted }

            // svg based icon
            Rectangle {
                width: 50
                height: 50
                color: "transparent"

                Image {
                    property int iconSize: 36
                    anchors.centerIn: parent
                    width: iconSize
                    height: iconSize
                    source: themeService.iconPath + "search.svg"
                    sourceSize.width: iconSize; sourceSize.height: iconSize
                    fillMode: Image.PreserveAspectFit
                    visible: true
                    layer.enabled: true
                    layer.effect: MultiEffect {
                        colorization: 1.0
                        colorizationColor: themeService.textMuted
                    }
                }
            }


            TextField {
                id: destField
                Layout.fillWidth: true
                placeholderText: "Search destination…"
                color: themeService.foreground
                placeholderTextColor: Qt.rgba(themeService.foreground.r, themeService.foreground.g, themeService.foreground.b, 0.4)
                font.family: themeService.fontQuicksand
                font.pixelSize: 17
                background: Item {}
                onAccepted: if (text.length > 0) navigationService.searchAddress(text)
            }

            // Spinner while searching
            Rectangle {
                width: 36; height: 36; radius: 18
                color: "transparent"
                border.color: themeService.primary; border.width: 2
                visible: navigationService.isSearching
                RotationAnimator on rotation {
                    from: 0; to: 360; duration: 800
                    loops: Animation.Infinite; running: navigationService.isSearching
                }
            }
            Rectangle {
                width: 38; height: 38; radius: 8; color: themeService.primary
                visible: !navigationService.isSearching
                Text { anchors.centerIn: parent; text: "→"; color: "#000"; font.pixelSize: 20; font.bold: true }
                MouseArea {
                    anchors.fill: parent
                    onClicked: if (destField.text.length > 0) navigationService.searchAddress(destField.text)
                }
            }
        }
    }

    // ── Directions panel — slides in from the left ────────────────────────────
    Rectangle {
        id: directionsPanel
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 310
        x: -width   // starts off-screen

        color: Qt.rgba(themeService.card.r, themeService.card.g, themeService.card.b, 0.97)

        Behavior on x { NumberAnimation { duration: 320; easing.type: Easing.OutCubic } }

        function open()  { x = 0 }
        function close() { x = -width }

        // Right-edge accent line
        Rectangle { anchors.right: parent.right; width: 2; height: parent.height; color: themeService.primary }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 0
            spacing: 0

            // Header — destination + totals
            Rectangle {
                Layout.fillWidth: true
                height: 110
                color: Qt.rgba(0.05, 0.04, 0.04, 1.0)

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 4

                    // Close button
                    RowLayout {
                        Layout.fillWidth: true
                        Text {
                            Layout.fillWidth: true
                            text: navigationService.destName
                            color: themeService.foreground
                            font.family: themeService.fontQuicksand
                            font.pixelSize: 15; font.weight: Font.DemiBold
                            elide: Text.ElideRight
                        }
                        Rectangle {
                            width: 28; height: 28; radius: 14
                            color: Qt.rgba(1,1,1,0.1)
                            Text { anchors.centerIn: parent; text: "✕"; color: themeService.textMuted; font.pixelSize: 14 }
                            MouseArea { anchors.fill: parent; onClicked: directionsPanel.close() }
                        }
                    }

                    RowLayout {
                        spacing: 16
                        Text {
                            text: navigationService.etaText
                            color: themeService.primary
                            font.family: themeService.fontOrbitron
                            font.pixelSize: 22; font.weight: Font.Bold
                        }
                        Text {
                            text: navigationService.totalDistText
                            color: themeService.textMuted
                            font.family: themeService.fontQuicksand
                            font.pixelSize: 15
                        }
                    }
                }
            }

            // Step list
            ListView {
                id: stepList
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                model: navigationService.steps

                ScrollBar.vertical: ScrollBar { policy: ScrollBar.AsNeeded }

                delegate: Rectangle {
                    required property var modelData
                    required property int index
                    width: stepList.width
                    height: 64
                    color: index % 2 === 0
                        ? Qt.rgba(themeService.card.r, themeService.card.g, themeService.card.b, 1.0)
                        : Qt.rgba(themeService.muted.r, themeService.muted.g, themeService.muted.b, 0.3)

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 14; anchors.rightMargin: 14
                        spacing: 12

                        // Direction icon
                        Rectangle {
                            width: 36; height: 36; radius: 6
                            color: index === 0
                                ? themeService.primary
                                : Qt.rgba(themeService.primary.r, themeService.primary.g, themeService.primary.b, 0.15)
                            Text {
                                anchors.centerIn: parent
                                text: stepIcon(modelData.type, modelData.modifier)
                                font.pixelSize: 18
                                color: index === 0 ? "#000" : themeService.primary
                            }
                        }

                        // Instruction text
                        Column {
                            Layout.fillWidth: true
                            spacing: 2
                            Text {
                                width: parent.width
                                text: modelData.instruction
                                color: themeService.foreground
                                font.family: themeService.fontQuicksand
                                font.pixelSize: 13
                                wrapMode: Text.WordWrap
                                maximumLineCount: 2
                                elide: Text.ElideRight
                            }
                            Text {
                                text: modelData.distanceText
                                color: themeService.textMuted
                                font.family: themeService.fontQuicksand
                                font.pixelSize: 11
                            }
                        }
                    }

                    // Row divider
                    Rectangle {
                        anchors.bottom: parent.bottom
                        width: parent.width; height: 1
                        color: themeService.border; opacity: 0.5
                    }
                }
            }

            // Start button
            Rectangle {
                Layout.fillWidth: true
                height: 72
                color: Qt.rgba(0.05, 0.04, 0.04, 1.0)

                Rectangle { anchors.top: parent.top; width: parent.width; height: 2; color: themeService.primary }

                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width - 32; height: 48; radius: 10
                    color: themeService.primary

                    Text {
                        anchors.centerIn: parent
                        text: "START"
                        color: "#000"
                        font.family: themeService.fontQuicksand
                        font.pixelSize: 16; font.weight: Font.Bold; font.letterSpacing: 2
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: navigationService.startNavigation()
                    }
                }
            }
        }
    }

    // ── Driving instruction card (top) ────────────────────────────────────────
    Rectangle {
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: 130
        color: Qt.rgba(0.05, 0.04, 0.04, 0.96)
        visible: navigationService.isNavigating

        Rectangle { anchors.bottom: parent.bottom; width: parent.width; height: 2; color: themeService.primary }

        RowLayout {
            anchors.fill: parent; anchors.margins: 16; spacing: 16

            Rectangle {
                width: 72; height: 72; radius: 10; color: themeService.primary
                Text {
                    anchors.centerIn: parent
                    text: stepIcon(
                        navigationService.steps.length > 0 ? navigationService.steps[navigationService.currentStep].type : "",
                        navigationService.steps.length > 0 ? navigationService.steps[navigationService.currentStep].modifier : "")
                    font.pixelSize: 36; color: "#000"
                }
            }

            Column {
                Layout.fillWidth: true; spacing: 4
                Text {
                    text: navigationService.distanceText
                    color: themeService.primary
                    font.family: themeService.fontOrbitron
                    font.pixelSize: 26; font.weight: Font.Bold
                }
                Text {
                    width: parent.width
                    text: navigationService.instruction
                    color: "#ffffff"
                    font.family: themeService.fontQuicksand
                    font.pixelSize: 15
                    wrapMode: Text.WordWrap; maximumLineCount: 2; elide: Text.ElideRight
                }
            }
        }
    }

    // ── Driving status bar (bottom) ───────────────────────────────────────────
    Rectangle {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        height: 70
        color: Qt.rgba(0.05, 0.04, 0.04, 0.96)
        visible: navigationService.isNavigating

        Rectangle { anchors.top: parent.top; width: parent.width; height: 2; color: themeService.primary }

        RowLayout {
            anchors.fill: parent; anchors.leftMargin: 20; anchors.rightMargin: 16; spacing: 0

            Column {
                spacing: 1
                Text { text: navigationService.etaText; color: themeService.primary; font.family: themeService.fontOrbitron; font.pixelSize: 20; font.weight: Font.Bold }
                Text { text: "ETA"; color: themeService.textMuted; font.family: themeService.fontQuicksand; font.pixelSize: 10; font.letterSpacing: 1.5 }
            }
            Rectangle { width: 1; height: 32; color: themeService.border; Layout.leftMargin: 14; Layout.rightMargin: 14 }
            Text {
                Layout.fillWidth: true
                text: navigationService.destName
                color: themeService.textMuted
                font.family: themeService.fontQuicksand; font.pixelSize: 14
                elide: Text.ElideRight
            }
            Rectangle {
                width: 44; height: 44; radius: 22; color: themeService.error
                Text { anchors.centerIn: parent; text: "✕"; color: "#fff"; font.pixelSize: 18 }
                MouseArea { anchors.fill: parent; onClicked: navigationService.stopNavigation() }
            }
        }
    }
}
