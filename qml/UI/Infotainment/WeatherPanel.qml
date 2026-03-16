import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import HMItestUI

Item {
    id: root
    Layout.fillWidth: true
    Layout.preferredHeight: 200
    Layout.leftMargin: 20
    Layout.rightMargin: 20

    // ── Day / night (re-evaluated every minute) ───────────────────────────────
    property bool isDay: true

    function updateDayNight() {
        const now   = new Date();
        const cur   = now.getHours() * 60 + now.getMinutes();
        const rise  = locationService.sunriseTime.split(":").map(Number);
        const set_  = locationService.sunsetTime.split(":").map(Number);
        isDay = (cur >= rise[0] * 60 + rise[1]) && (cur < set_[0] * 60 + set_[1]);
    }

    Timer {
        interval: 60000; repeat: true; running: true; triggeredOnStart: true
        onTriggered: root.updateDayNight()
    }

    // ── Weather image mapping ────────────────────────────────────────────────
    property string weatherImage: {
        const b = themeService.imagePath + "weather/";
        const c = weatherService.weatherCode;
        const d = root.isDay;
        if (c <= 1) return b + (d ? "clearday.png" : "clearnight.png");
        if (c === 2) return b + (d ? "partlycloudyday.png" : "partlycloudynight.png");
        if (c === 3) return b + "overcast.png";
        if (c === 45 || c === 48) return b + "foggy.png";
        if (c >= 51 && c <= 55) return b + (d ? "rainingday.png" : "rainingnight.png");
        if (c === 56 || c === 57) return b + "sleet.png";
        if (c >= 61 && c <= 65) return b + (d ? "rainingday.png" : "rainingnight.png");
        if (c === 66 || c === 67) return b + "sleet.png";
        if (c >= 71 && c <= 77) return b + (d ? "snowingday.png" : "snowingnight.png");
        if (c >= 80 && c <= 82) return b + (d ? "showersday.png" : "showersnight.png");
        if (c >= 85 && c <= 86) return b + (d ? "snowingday.png" : "snowingnight.png");
        if (c >= 95) return b + "thunderstorms.png";
        return b + (d ? "clearday.png" : "clearnight.png");
    }

    // ── Display helpers ──────────────────────────────────────────────────────
    function displayTemp() {
        if (unitsService.displayOutsideTemp <= -999) return "--";
        return unitsService.displayOutsideTemp.toFixed(1);
    }

    function displayFeelsLike() {
        if (!weatherService.hasData || weatherService.feelsLike <= -999) return "--";
        const v = settingsService.metricUnits
            ? weatherService.feelsLike
            : (weatherService.feelsLike * 9 / 5 + 32);
        return "Feels like " + v.toFixed(1) + " " + unitsService.outsideTempUnit;
    }

    function displayWindSpeed() {
        if (!weatherService.hasData) return "--";
        return settingsService.metricUnits
            ? weatherService.windSpeed.toFixed(0) + " km/h"
            : (weatherService.windSpeed * 0.621371).toFixed(0) + " mph";
    }

    function toCardinal(deg) {
        const dirs = ["N","NNE","NE","ENE","E","ESE","SE","SSE",
                      "S","SSW","SW","WSW","W","WNW","NW","NNW"];
        return dirs[Math.round(deg / 22.5) % 16];
    }

    // ── Panel background ─────────────────────────────────────────────────────
    Glass {
        id: panelBg
        anchors.fill: parent

        RowLayout {
            anchors.fill: parent
            spacing: 0

            // ── Left: image pane ─────────────────────────────────────────────
            Item {
                Layout.preferredWidth: 699
                Layout.preferredHeight: 198
                Layout.leftMargin: 1
                clip: true

                // Weather photograph
                Image {
                    anchors.fill: parent
                    source: root.weatherImage
                    fillMode: Image.PreserveAspectCrop
                    opacity: status === Image.Ready ? 1.0 : 0.0
                    Behavior on opacity { NumberAnimation { duration: 400 } }
                }

                // Left-side text shadow (improves overlay readability)
                Rectangle {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: parent.width * 0.65
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0.0; color: Qt.rgba(0, 0, 0, 0.75) }
                        GradientStop { position: 0.4; color: Qt.rgba(0, 0, 0, 0.55) }
                        GradientStop { position: 1.0; color: "transparent" }
                    }
                }

                // Right fade — blends image into panel background
                Rectangle {
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    width: 200
                    gradient: Gradient {
                        orientation: Gradient.Horizontal
                        GradientStop { position: 0.0; color: "transparent" }
                        GradientStop { position: 1.0; color: Qt.rgba(0, 0, 0, 0.55) }
                    }
                }

                // ── Overlaid text ────────────────────────────────────────────
                Column {
                    anchors.left: parent.left
                    anchors.leftMargin: 28
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: 2

                    // Condition label
                    Text {
                        text: weatherService.condition.toUpperCase()
                        font.family: themeService.fontOxanium
                        font.pixelSize: 16
                        font.letterSpacing: 2
                        color: "white"
                        opacity: 0.85
                    }

                    // Temperature + unit
                    Row {
                        spacing: 4
                        Text {
                            text: root.displayTemp()
                            font.family: themeService.fontOxanium
                            font.pixelSize: 72
                            font.weight: Font.Medium
                            color: "white"
                        }
                        Text {
                            text: unitsService.outsideTempUnit
                            font.family: themeService.fontOxanium
                            font.pixelSize: 28
                            font.weight: Font.Light
                            color: "white"
                            opacity: 0.8
                            anchors.bottom: parent.bottom
                            anchors.bottomMargin: 14
                        }
                    }

                    // Feels like
                    Text {
                        text: root.displayFeelsLike()
                        font.family: themeService.fontOxanium
                        font.pixelSize: 14
                        color: "white"
                        opacity: 0.72
                    }
                }
            }

            // ── Right: data table ────────────────────────────────────────────
            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                // Left border line
                Rectangle {
                    anchors.left: parent.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.topMargin: 14
                    anchors.bottomMargin: 14
                    width: 1
                    color: themeService.border
                    opacity: 0.5
                    Behavior on color { ColorAnimation { duration: themeService.toggleTimer } }
                }

                Column {
                    id: datacolumn
                    property int fontSize: 14
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: 20
                    anchors.rightMargin: 16
                    spacing: 0

                    // ── Data row component (inline) ──────────────────────────
                    // Wind Speed
                    Item {
                        width: parent.width; height: 34
                        Rectangle { anchors.top: parent.top; width: parent.width; height: 1; color: themeService.border; opacity: 0.25; Behavior on color { ColorAnimation { duration: themeService.toggleTimer } } }
                        Text { anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter; text: "Wind Speed"; font.family: themeService.fontOxanium; font.pixelSize: datacolumn.fontSize; color: themeService.textMuted; Behavior on color { ColorAnimation { duration: themeService.toggleTimer } } }
                        Text { anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter; text: root.displayWindSpeed(); font.family: themeService.fontOxanium; font.pixelSize: 14; font.weight: Font.Medium; color: themeService.foreground; Behavior on color { ColorAnimation { duration: themeService.toggleTimer } } }
                    }

                    // Wind Direction
                    Item {
                        width: parent.width; height: 34
                        Rectangle { anchors.top: parent.top; width: parent.width; height: 1; color: themeService.border; opacity: 0.25; Behavior on color { ColorAnimation { duration: themeService.toggleTimer } } }
                        Text { anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter; text: "Wind Direction"; font.family: themeService.fontOxanium; font.pixelSize: datacolumn.fontSize; color: themeService.textMuted; Behavior on color { ColorAnimation { duration: themeService.toggleTimer } } }
                        Text { anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter; text: weatherService.hasData ? root.toCardinal(weatherService.windDirection) + "  " + weatherService.windDirection + "°" : "--"; font.family: themeService.fontOxanium; font.pixelSize: 14; font.weight: Font.Medium; color: themeService.foreground; Behavior on color { ColorAnimation { duration: themeService.toggleTimer } } }
                    }

                    // Humidity
                    Item {
                        width: parent.width; height: 34
                        Rectangle { anchors.top: parent.top; width: parent.width; height: 1; color: themeService.border; opacity: 0.25; Behavior on color { ColorAnimation { duration: themeService.toggleTimer } } }
                        Text { anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter; text: "Humidity"; font.family: themeService.fontOxanium; font.pixelSize: datacolumn.fontSize; color: themeService.textMuted; Behavior on color { ColorAnimation { duration: themeService.toggleTimer } } }
                        Text { anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter; text: weatherService.hasData ? weatherService.humidity + " %" : "--"; font.family: themeService.fontOxanium; font.pixelSize: 14; font.weight: Font.Medium; color: themeService.foreground; Behavior on color { ColorAnimation { duration: themeService.toggleTimer } } }
                    }

                    // Precipitation Chance
                    Item {
                        width: parent.width; height: 34
                        Rectangle { anchors.top: parent.top; width: parent.width; height: 1; color: themeService.border; opacity: 0.25; Behavior on color { ColorAnimation { duration: themeService.toggleTimer } } }
                        Text { anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter; text: "Precip Chance"; font.family: themeService.fontOxanium; font.pixelSize: datacolumn.fontSize; color: themeService.textMuted; Behavior on color { ColorAnimation { duration: themeService.toggleTimer } } }
                        Text { anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter; text: weatherService.hasData ? weatherService.precipitationProbability + " %" : "--"; font.family: themeService.fontOxanium; font.pixelSize: 14; font.weight: Font.Medium; color: themeService.foreground; Behavior on color { ColorAnimation { duration: themeService.toggleTimer } } }
                    }

                    // Precipitation Amount
                    Item {
                        width: parent.width; height: 34
                        Rectangle { anchors.top: parent.top; width: parent.width; height: 1; color: themeService.border; opacity: 0.25; Behavior on color { ColorAnimation { duration: themeService.toggleTimer } } }
                        Text { anchors.left: parent.left; anchors.verticalCenter: parent.verticalCenter; text: "Precipitation"; font.family: themeService.fontOxanium; font.pixelSize: datacolumn.fontSize; color: themeService.textMuted; Behavior on color { ColorAnimation { duration: themeService.toggleTimer } } }
                        Text { anchors.right: parent.right; anchors.verticalCenter: parent.verticalCenter; text: weatherService.hasData ? weatherService.precipitation.toFixed(1) + " mm" : "--"; font.family: themeService.fontOxanium; font.pixelSize: 14; font.weight: Font.Medium; color: themeService.foreground; Behavior on color { ColorAnimation { duration: themeService.toggleTimer } } }
                    }
                }
            }
        }
    }
}
