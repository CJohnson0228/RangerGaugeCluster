// Settings Window for InstrumentData display
import QtQuick
import QtQuick.Layouts
import HMItestUI

Item {
    id: root
    anchors.fill: parent
    clip: true

    // Main settings list
    Column {
        id: mainMenu
        anchors.fill: parent
        anchors.margins: 10
        spacing: 0

        // Theme
        SettingsRow {
            width: parent.width
            label: "Theme"
            valueText: settingsService.themeBehavior === "dark" ? "Dark"
                : settingsService.themeBehavior === "light" ? "Light" : "Auto"
            onTapped: {
                var modes = ["auto", "light", "dark"]
                var next = (modes.indexOf(settingsService.themeBehavior) + 1) % 3
                settingsService.themeBehavior = modes[next]
            }
        }

        // Units
        SettingsRow {
            width: parent.width
            label: "Units"
            valueText: settingsService.metricUnits ? "Metric" : "Imperial"
            onTapped: settingsService.metricUnits = !settingsService.metricUnits
        }

        // Door Auto-Lock
        SettingsRow {
            width: parent.width
            label: "Door Auto-Lock"
            valueText: settingsService.doorAutoLock ? "On" : "Off"
            onTapped: settingsService.doorAutoLock = !settingsService.doorAutoLock
        }

        // DRL Lights
        SettingsRow {
            width: parent.width
            label: "DRL Lights"
            valueText: settingsService.drlLights ? "On" : "Off"
            onTapped: settingsService.drlLights = !settingsService.drlLights
        }

        // Maintenance
        SettingsRow {
            width: parent.width
            label: "Maintenance"
            valueText: "›"
            onTapped: maintMenu.open()
        }
    }

    // Maintenance submenu — slides in from the left
    Item {
        id: maintMenu
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: parent.width
        x: -width
        visible: x > -width - 1

        function open()  { slideIn.start() }
        function close() { slideOut.start() }

        NumberAnimation on x {
            id: slideIn
            to: 0
            duration: 250
            easing.type: Easing.OutCubic
        }
        NumberAnimation on x {
            id: slideOut
            to: -maintMenu.width
            duration: 250
            easing.type: Easing.InCubic
        }

        Rectangle {
            anchors.fill: parent
            color: themeService.background
            Behavior on color { ColorAnimation { duration: themeService.toggleTimer }}
        }

        Column {
            anchors.fill: parent
            anchors.margins: 10
            spacing: 0

            // Header
            Text {
                width: parent.width
                text: "Maintenance"
                font.family: themeService.fontOxanium
                font.pixelSize: 13
                color: themeService.textMuted
                topPadding: 4
                bottomPadding: 10
            }

            // Interval — distance
            SettingsRow {
                width: parent.width
                label: "Interval (" + unitsService.distanceUnit + ")"
                valueText: settingsService.maintenanceIntervalMiles.toString()
            }

            // Interval — time
            SettingsRow {
                width: parent.width
                label: "Interval (months)"
                valueText: Math.round(settingsService.maintenanceIntervalDays / 30).toString()
            }

            // Reset
            SettingsRow {
                width: parent.width
                label: "Reset Countdown"
                valueText: "↺"
                onTapped: { /* wire up when countdown logic is implemented */ }
            }

            // Return
            SettingsRow {
                width: parent.width
                label: "‹ Back"
                valueText: ""
                onTapped: maintMenu.close()
            }
        }
    }
}