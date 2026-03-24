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
        "OFF", "Vents", "Vents + Floor", "Floor", "Defrost + Floor", "Defrost", "A/C", "MAX",
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

    readonly property int pad: 16       // outer margin
    readonly property int gap: 20       // spacing between sections and dividers
    readonly property int divInset: 16  // top/bottom inset on dividers
    readonly property int btnWidth: 90  // shared button width for fan + duct

    RowLayout {
        anchors.fill: parent
        anchors.margins: pad
        spacing: gap

        // ── Section 1: Temperature Ring ──────────────────────────────────────
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            TempRingControl {
                anchors.centerIn: parent
            }
        }

        // ── Divider ──────────────────────────────────────────────────────────
        Rectangle {
            width: 1
            Layout.fillHeight: true
            Layout.topMargin: divInset
            Layout.bottomMargin: divInset
            color: themeService.border
            opacity: 0.5
            Behavior on color { ColorAnimation { duration: themeService.toggleTimer }}
        }

        // ── Section 2: Fan Speed ─────────────────────────────────────────────
        Item {
            Layout.preferredWidth: 20 + 8 + btnWidth  // label + spacing + buttons
            Layout.fillHeight: true

            RowLayout {
                anchors.fill: parent
                spacing: 14

                Item {
                    Layout.preferredWidth: 20
                    Layout.fillHeight: true
                    Text {
                        anchors.centerIn: parent
                        text: "Fan Speed"
                        rotation: -90
                        font.family: themeService.fontOrbitron
                        font.pixelSize: 20
                        font.letterSpacing: 1.5
                        color: themeService.textMuted
                        Behavior on color { ColorAnimation { duration: themeService.toggleTimer }}
                    }
                }

                ColumnLayout {
                    spacing: 6
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Repeater {
                        model: 4
                        HMIButton {
                            required property int index
                            readonly property int level: 4 - index

                            Layout.preferredWidth: btnWidth
                            Layout.fillHeight: true
                            active: level === climateService.fanSpeed
                            onClicked: climateService.fanSpeed = level

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
                                        color: (level === climateService.fanSpeed) ? themeService.background : themeService.textMuted
                                        Behavior on color { ColorAnimation { duration: 150 }}
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        // ── Divider ──────────────────────────────────────────────────────────
        Rectangle {
            width: 1
            Layout.fillHeight: true
            Layout.topMargin: divInset
            Layout.bottomMargin: divInset
            color: themeService.border
            opacity: 0.5
            Behavior on color { ColorAnimation { duration: themeService.toggleTimer }}
        }

        // ── Section 3: Duct Mode Grid ────────────────────────────────────────
        RowLayout {
            Layout.preferredWidth: 20 + 8 + 2 * btnWidth + 6  // label + spacing + grid
            Layout.fillHeight: true
            spacing: 14

            Item {
                Layout.preferredWidth: 20
                Layout.fillHeight: true
                Text {
                    anchors.centerIn: parent
                    text: "Mode Selection"
                    rotation: -90
                    font.family: themeService.fontOrbitron
                    font.pixelSize: 20
                    font.letterSpacing: 1.5
                    color: themeService.textMuted
                    Behavior on color { ColorAnimation { duration: themeService.toggleTimer }}
                }
            }

        GridLayout {
            Layout.preferredWidth: 2 * btnWidth + 6
            Layout.fillHeight: true
            columns: 2
            columnSpacing: 6
            rowSpacing: 6

            Repeater {
                model: ductModes
                HMIButton {
                    required property int index
                    required property string modelData

                    Layout.preferredWidth: btnWidth
                    Layout.fillHeight: true
                    active: index === climateService.ductMode
                    onClicked: climateService.ductMode = index

                    Image {
                        readonly property int sz: 34
                        visible: ductIcons[index] !== ""
                        anchors.centerIn: parent
                        width: sz; height: sz
                        sourceSize.width: sz; sourceSize.height: sz
                        source: ductIcons[index] !== "" ? themeService.iconPath + ductIcons[index] : ""
                        fillMode: Image.PreserveAspectFit
                        layer.enabled: true
                        layer.effect: MultiEffect {
                            colorization: 1.0
                            colorizationColor: (index === climateService.ductMode) ? themeService.background : themeService.textMuted
                            Behavior on colorizationColor { ColorAnimation { duration: 150 }}
                        }
                    }

                    Text {
                        visible: ductIcons[index] === ""
                        anchors.centerIn: parent
                        text: modelData
                        font.family: themeService.fontOxanium
                        font.pixelSize: 20
                        font.letterSpacing: 1
                        font.weight: Font.Medium
                        color: (index === climateService.ductMode) ? themeService.background : themeService.textMuted
                        Behavior on color { ColorAnimation { duration: 150 }}
                    }
                }
            }
        }  // GridLayout
        }  // Section 3 RowLayout
    }
}
