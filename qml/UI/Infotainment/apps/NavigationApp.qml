import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtLocation
import QtPositioning
import HMItestUI

Glass {
    anchors.fill: parent

    Plugin {
        id: mapPlugin
        name: "maplibre"
        PluginParameter { name: "maplibre.api.provider"; value: "mapbox" }
        PluginParameter { name: "maplibre.api.key";      value: navigationService.accessToken }
        PluginParameter { name: "maplibre.map.styles";   value: "mapbox://styles/mapbox/navigation-night-v1" }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // ── Search bar ────────────────────────────────────────────────────────
        Rectangle {
            Layout.fillWidth: true
            Layout.margins: 10
            height: 48
            radius: 6
            color: themeService.card

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 12
                anchors.rightMargin: 8
                spacing: 8

                TextField {
                    id: destField
                    Layout.fillWidth: true
                    placeholderText: "Search destination…"
                    color: themeService.foreground
                    placeholderTextColor: Qt.rgba(
                        Qt.color(themeService.foreground).r,
                        Qt.color(themeService.foreground).g,
                        Qt.color(themeService.foreground).b, 0.4)
                    font.family: themeService.fontQuicksand
                    font.pixelSize: 15
                    background: Item {}
                    onAccepted: if (text.length > 0) navigationService.searchAddress(text)
                }

                // Spinner while searching
                Rectangle {
                    width: 32; height: 32
                    radius: 16
                    color: "transparent"
                    border.color: themeService.primary
                    border.width: 2
                    visible: navigationService.isSearching
                    RotationAnimator on rotation {
                        from: 0; to: 360; duration: 900
                        loops: Animation.Infinite
                        running: navigationService.isSearching
                    }
                }

                // Search button
                Rectangle {
                    width: 36; height: 36
                    radius: 4
                    color: themeService.primary
                    visible: !navigationService.isSearching
                    Text {
                        anchors.centerIn: parent
                        text: "→"
                        color: "white"
                        font.pixelSize: 18
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: if (destField.text.length > 0) navigationService.searchAddress(destField.text)
                    }
                }
            }
        }

        // ── Route-ready bar (shows after fetch, before Start) ─────────────────
        Rectangle {
            Layout.fillWidth: true
            height: visible ? 54 : 0
            color: themeService.primary
            visible: !navigationService.isNavigating
                  && navigationService.destName !== ""
                  && !navigationService.isSearching

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: 16
                anchors.rightMargin: 12
                spacing: 10

                Text {
                    Layout.fillWidth: true
                    text: navigationService.destName + "  ·  " + navigationService.etaText
                    color: "white"
                    font.family: themeService.fontQuicksand
                    font.pixelSize: 15
                    elide: Text.ElideRight
                }

                Rectangle {
                    width: 76; height: 36
                    radius: 4
                    color: "white"
                    Text {
                        anchors.centerIn: parent
                        text: "Start"
                        color: themeService.primary
                        font.family: themeService.fontQuicksand
                        font.pixelSize: 14
                        font.bold: true
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: navigationService.startNavigation()
                    }
                }
            }
        }

        // ── Map ───────────────────────────────────────────────────────────────
        MapView {
            id: mapView
            Layout.fillWidth: true
            Layout.fillHeight: true
            map.plugin: mapPlugin
            map.center: QtPositioning.coordinate(locationService.latitude, locationService.longitude)
            map.zoomLevel: 13

            // Route polyline
            MapPolyline {
                line.color: themeService.primary
                line.width: 6
                path: navigationService.routePath
                visible: navigationService.routePath.length > 0
            }

            // Current position dot
            MapQuickItem {
                coordinate: QtPositioning.coordinate(locationService.latitude, locationService.longitude)
                anchorPoint.x: 12
                anchorPoint.y: 12
                sourceItem: Rectangle {
                    width: 24; height: 24; radius: 12
                    color: themeService.primary
                    border.color: "white"
                    border.width: 3
                }
            }
        }

        // ── Turn-by-turn overlay ──────────────────────────────────────────────
        Rectangle {
            Layout.fillWidth: true
            height: visible ? 84 : 0
            color: themeService.card
            visible: navigationService.isNavigating

            RowLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 12

                Column {
                    Layout.fillWidth: true
                    spacing: 3
                    Text {
                        width: parent.width
                        text: navigationService.instruction
                        color: themeService.foreground
                        font.family: themeService.fontQuicksand
                        font.pixelSize: 15
                        wrapMode: Text.WordWrap
                    }
                    Text {
                        text: navigationService.distanceText
                        color: themeService.foreground
                        font.family: themeService.fontQuicksand
                        font.pixelSize: 13
                        opacity: 0.65
                    }
                }

                Column {
                    spacing: 2
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: navigationService.etaText
                        color: themeService.primary
                        font.family: themeService.fontOrbitron
                        font.pixelSize: 17
                    }
                    Text {
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: "ETA"
                        color: themeService.foreground
                        font.family: themeService.fontQuicksand
                        font.pixelSize: 11
                        opacity: 0.5
                    }
                }

                // Stop navigation
                Rectangle {
                    width: 48; height: 48; radius: 24
                    color: "#cc2222"
                    Text {
                        anchors.centerIn: parent
                        text: "✕"
                        color: "white"
                        font.pixelSize: 20
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: navigationService.stopNavigation()
                    }
                }
            }
        }
    }

    // Pan map to mid-route when route arrives
    Connections {
        target: navigationService
        function onRouteReady() {
            const path = navigationService.routePath
            if (path.length > 0) {
                const mid = path[Math.floor(path.length / 2)]
                mapView.map.center = QtPositioning.coordinate(mid.latitude, mid.longitude)
                mapView.map.zoomLevel = 11
            }
        }
    }
}
