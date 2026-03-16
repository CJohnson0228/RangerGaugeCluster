import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Effects
import HMItestUI

Glass {
    Layout.fillWidth: true
    Layout.preferredHeight: 300
    Layout.leftMargin:  20
    Layout.rightMargin: 20

    // Duct mode labels (index matches ClimateService.ductMode)
    readonly property var ductModes: [
        "OFF", "Vents", "Vents + Floor", "Floor", "Defrost + Floor", "Defrost",
         "A/C", "MAX",
    ]

    // Icon file for each duct mode — empty string means text-only
    readonly property var ductIcons: [
        "",
        "ClimateControl/vents.svg",
        "ClimateControl/floorvents.svg",
        "ClimateControl/floor.svg",
        "ClimateControl/floordefrost.svg",
        "ClimateControl/defrost.svg",
        "", ""
    ]

    RowLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 0

        // ── Section 1: Temperature Dial ──────────────────────────────────────
        Item {
            Layout.preferredWidth: 280
            Layout.fillHeight: true

            Dial {
                id: tempDial
                anchors.centerIn: parent
                width: 240; height: 240

                minValue: settingsService.metricUnits ? 15  : 60
                maxValue: settingsService.metricUnits ? 32  : 90
                unit:     settingsService.metricUnits ? "°C" : "°F"
                label: "TEMP"
                arcEndColor: settingsService.metricUnits
                    ? (value >= 24 ? themeService.error : themeService.info)
                    : (value >= 75 ? themeService.error : themeService.info)
                arcBackgroundColor: themeService.card
                dialBackgroundColor: themeService.background

                property bool syncingFromService: false

                // Write raw °C back to service, converting if needed
                onValueChanged: {
                    if (!syncingFromService)
                        climateService.temperature = settingsService.metricUnits
                            ? value
                            : (value - 32) * 5 / 9
                }

                // Sync dial when service value or units change externally
                function syncFromService() {
                    syncingFromService = true
                    animated = false
                    value = settingsService.metricUnits
                        ? climateService.temperature
                        : climateService.temperature * 9 / 5 + 32
                    syncingFromService = false
                    Qt.callLater(function() { animated = true })
                }

                Component.onCompleted: syncFromService()

                Connections {
                    target: climateService
                    function onTemperatureChanged() { tempDial.syncFromService() }
                }
                Connections {
                    target: settingsService
                    function onMetricUnitsChanged() { tempDial.syncFromService() }
                }
            }
        }

        // Spacer
        Item { Layout.fillWidth: true }


        // ── Divider ──────────────────────────────────────────────────────────
        Rectangle {
            width: 1; Layout.fillHeight: true
            Layout.topMargin: 20; Layout.bottomMargin: 20
            color: themeService.border; opacity: 0.5
            Behavior on color { ColorAnimation { duration: themeService.toggleTimer }}
        }

        // ── Section 2: Fan Speed ─────────────────────────────────────────────
        Item {
            Layout.preferredWidth: 220
            Layout.fillHeight: true
            Layout.leftMargin: 10
            Layout.rightMargin: 10

            RowLayout {
                anchors.fill : parent
                spacing: 10

                Image {
                    readonly property int iconSize: 24
                    Layout.alignment: Qt.AlignVCenter
                    width: iconSize; height: iconSize
                    sourceSize.width: iconSize; sourceSize.height: iconSize
                    source: themeService.iconPath + "ClimateControl/fan.svg"
                    fillMode: Image.PreserveAspectFit
                    layer.enabled: true
                    layer.effect: MultiEffect {
                        colorization: 1.0
                        colorizationColor: themeService.foreground
                        Behavior on colorizationColor { ColorAnimation { duration: 150 }}
                    }
                }

                // Stepped fan selector — 4 speed levels, stacked vertically
                Column {
                    spacing: 6
                    Layout.fillWidth: true
                    Layout.fillHeight: true


                    Repeater {
                        model: 4
                        Rectangle {
                            required property int index
                            readonly property int  level:  4 - index  // 4 at top, 1 at bottom
                            readonly property bool active: level === climateService.fanSpeed

                            width: parent.width; height: 46; radius: 6
                            color: active ? themeService.primary : themeService.card
                            border.color: active ? themeService.primary : themeService.border
                            border.width: 1

                            Behavior on color        { ColorAnimation { duration: 150 }}
                            Behavior on border.color { ColorAnimation { duration: 150 }}

                            // Bar indicators only — no number label
                            Row {
                                anchors.centerIn: parent
                                spacing: 3

                                Repeater {
                                    model: level
                                    Rectangle {
                                        required property int index
                                        width: 6
                                        height: 6 + index * 5
                                        radius: 2
                                        anchors.bottom: parent.bottom
                                        color: active ? themeService.background : themeService.textMuted
                                        Behavior on color { ColorAnimation { duration: 150 }}
                                    }
                                }
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: climateService.fanSpeed = level
                            }
                        }
                    }
                }
            }
        }

        // ── Divider ──────────────────────────────────────────────────────────
        Rectangle {
            width: 1; Layout.fillHeight: true
            Layout.topMargin: 20; Layout.bottomMargin: 20
            Layout.leftMargin: 20; Layout.rightMargin: 20
            color: themeService.border; opacity: 0.5
            Behavior on color { ColorAnimation { duration: themeService.toggleTimer }}
        }

        // ── Section 3: Duct Mode Grid ────────────────────────────────────────
        GridLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            columns: 2
            columnSpacing: 6
            rowSpacing: 6

            Repeater {
                model: ductModes
                Rectangle {
                    required property int index
                    required property string modelData

                    readonly property bool active: index === climateService.ductMode

                    Layout.preferredWidth: 100
                    Layout.fillHeight: true
                    radius: 6
                    color: active ? themeService.primary : themeService.card
                    border.color: active ? themeService.primary : themeService.border
                    border.width: 1

                    Behavior on color        { ColorAnimation { duration: 150 }}
                    Behavior on border.color { ColorAnimation { duration: 150 }}

                    // Icon buttons
                    Image {
                        readonly property int iconSize: 36
                        visible: ductIcons[index] !== ""
                        anchors.centerIn: parent
                        width: iconSize; height: iconSize
                        sourceSize.width: iconSize; sourceSize.height: iconSize
                        source: ductIcons[index] !== ""
                            ? themeService.iconPath + ductIcons[index]
                            : ""
                        fillMode: Image.PreserveAspectFit
                        layer.enabled: true
                        layer.effect: MultiEffect {
                            colorization: 1.0
                            colorizationColor: active ? themeService.background : themeService.textMuted
                            Behavior on colorizationColor { ColorAnimation { duration: 150 }}
                        }
                    }

                    // Text-only buttons (A/C, Max A/C, Off)
                    Text {
                        visible: ductIcons[index] === ""
                        anchors.centerIn: parent
                        text: modelData
                        font.family: themeService.fontOxanium
                        font.pixelSize: 22
                        font.letterSpacing: 1
                        font.weight: Font.Medium
                        color: active ? themeService.background : themeService.textMuted
                        Behavior on color { ColorAnimation { duration: 150 }}
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: climateService.ductMode = index
                    }
                }
            }
        }
    }
}
