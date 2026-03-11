import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import HMItestUI

ApplicationWindow {
    id: root
    visible: true
    width: 400
    height: 1200
    title: "Dev Panel"

    Timer {
        id: leftBlinkTimer
        interval: 500
        repeat: true
        onTriggered: vehicleState.leftTurnActive = !vehicleState.leftTurnActive
    }

    Timer {
        id: rightBlinkTimer
        interval: 500
        repeat: true
        onTriggered: vehicleState.rightTurnActive = !vehicleState.rightTurnActive
    }

    ScrollView {
        anchors.fill: parent

        GridLayout {
            width: 400
            columns: 2
            columnSpacing: 2
            rowSpacing: 4

            // Turn Signals
            Button {
                Layout.fillWidth: true
                text: "Left Turn"
                onClicked: {
                    if (leftBlinkTimer.running) {
                        leftBlinkTimer.stop()
                        vehicleState.leftTurnActive = false
                    } else {
                        leftBlinkTimer.start()
                    }
                }
            }
            Button {
                Layout.fillWidth: true
                text: "Right Turn"
                onClicked: {
                    if (rightBlinkTimer.running) {
                        rightBlinkTimer.stop()
                        vehicleState.rightTurnActive = false
                    } else {
                        rightBlinkTimer.start()
                    }
                }
            }
            Button {
                Layout.columnSpan: 2
                Layout.fillWidth: true
                text: "Hazards"
                onClicked: {
                    if (leftBlinkTimer.running || rightBlinkTimer.running) {
                        leftBlinkTimer.stop()
                        rightBlinkTimer.stop()
                        vehicleState.leftTurnActive = false
                        vehicleState.rightTurnActive = false
                    } else {
                        leftBlinkTimer.start()
                        rightBlinkTimer.start()
                    }
                }
            }

            // Section header
            Text { Layout.columnSpan: 2; text: "── Vehicle Data (raw metric) ──"; color: "white"; font.pixelSize: 11 }

            // Speed — km/h raw
            Text { text: "Speed (km/h)"; color: "white" }
            Slider {
                Layout.fillWidth: true
                from: 0; to: 200
                value: vehicleState.vehicleSpeed
                onValueChanged: vehicleState.vehicleSpeed = value
            }

            // RPM
            Text { text: "RPM"; color: "white" }
            Slider {
                Layout.fillWidth: true
                from: 0; to: 7000
                value: vehicleState.engineRPM
                onValueChanged: vehicleState.engineRPM = value
            }

            // Engine temp — °C raw
            Text { text: "Engine Temp (°C)"; color: "white" }
            Slider {
                Layout.fillWidth: true
                from: 40; to: 120
                value: vehicleState.engineTemp
                onValueChanged: vehicleState.engineTemp = value
            }

            // Fuel level — normalized 0.0–1.0
            Text { text: "Fuel Level (0–1)"; color: "white" }
            Slider {
                Layout.fillWidth: true
                from: 0; to: 1.0; stepSize: 0.01
                value: vehicleState.fuelLevel
                onValueChanged: vehicleState.fuelLevel = value
            }

            // Fuel economy — stored as mpg (0 = engine idle/stopped)
            Text { text: "Fuel Eco Live (mpg)"; color: "white" }
            Slider {
                Layout.fillWidth: true
                from: 0; to: 30; stepSize: 0.1
                value: vehicleState.fuelEconomyLive
                onValueChanged: vehicleState.fuelEconomyLive = value
            }
            Text { text: "Fuel Eco Avg (mpg)"; color: "white" }
            Slider {
                Layout.fillWidth: true
                from: 0; to: 30; stepSize: 0.1
                value: vehicleState.fuelEconomyAverage
                onValueChanged: vehicleState.fuelEconomyAverage = value
            }

            // Section header
            Text { Layout.columnSpan: 2; text: "── Location Data (raw metric) ──"; color: "white"; font.pixelSize: 11 }

            // Speed limit — km/h raw
            Text { text: "Speed Limit (km/h)"; color: "white" }
            SpinBox {
                from: 0; to: 130; stepSize: 10
                value: Math.round(locationService.localSpeedLimit)
                onValueModified: locationService.localSpeedLimit = value
            }

            // Outside temperature — °C raw (-999 = no data)
            Text { text: "Outside Temp (°C)"; color: "white" }
            Slider {
                Layout.fillWidth: true
                from: -40; to: 50; stepSize: 0.5
                value: locationService.outsideTemp >= -999 ? locationService.outsideTemp : -40
                onValueChanged: locationService.outsideTemp = value
            }
            Button {
                Layout.columnSpan: 2; Layout.fillWidth: true
                text: "Outside Temp: No Data"
                onClicked: locationService.outsideTemp = -999
            }

            // Section header
            Text { Layout.columnSpan: 2; text: "── Connectivity ──"; color: "white"; font.pixelSize: 11 }

            Button {
                Layout.columnSpan: 2; Layout.fillWidth: true
                text: "Bluetooth: " + (connectivityService.btConnected ? "Connected" : "Disconnected")
                onClicked: connectivityService.btConnected = !connectivityService.btConnected
            }
            Text { text: "Cell Signal (bars)"; color: "white" }
            SpinBox {
                from: 0; to: 5
                value: connectivityService.cellSignalBars
                onValueModified: connectivityService.cellSignalBars = value
            }

            // Section header
            Text { Layout.columnSpan: 2; text: "── Tire Pressures (kPa) ──"; color: "white"; font.pixelSize: 11 }

            Text { text: "Front Left"; color: "white" }
            Slider { Layout.fillWidth: true; from: 0; to: 400; value: vehicleState.tirePressLF; onValueChanged: vehicleState.tirePressLF = value }
            Text { text: "Front Right"; color: "white" }
            Slider { Layout.fillWidth: true; from: 0; to: 400; value: vehicleState.tirePressRF; onValueChanged: vehicleState.tirePressRF = value }
            Text { text: "Rear Left"; color: "white" }
            Slider { Layout.fillWidth: true; from: 0; to: 400; value: vehicleState.tirePressLR; onValueChanged: vehicleState.tirePressLR = value }
            Text { text: "Rear Right"; color: "white" }
            Slider { Layout.fillWidth: true; from: 0; to: 400; value: vehicleState.tirePressRR; onValueChanged: vehicleState.tirePressRR = value }

            // Section header
            Text { Layout.columnSpan: 2; text: "── Warning Indicators ──"; color: "white"; font.pixelSize: 11 }

            Button { Layout.fillWidth: true; text: "Battery";       onClicked: vehicleState.batteryWarningActive = !vehicleState.batteryWarningActive }
            Button { Layout.fillWidth: true; text: "Brake";         onClicked: vehicleState.brakeWarningActive = !vehicleState.brakeWarningActive }
            Button { Layout.fillWidth: true; text: "Coolant Temp";  onClicked: vehicleState.coolantTempWarningActive = !vehicleState.coolantTempWarningActive }
            Button { Layout.fillWidth: true; text: "Parking Brake"; onClicked: vehicleState.parkingBrakeWarningActive = !vehicleState.parkingBrakeWarningActive }
            Button { Layout.fillWidth: true; text: "Oil";           onClicked: vehicleState.oilWarningActive = !vehicleState.oilWarningActive }
            Button { Layout.fillWidth: true; text: "Seatbelt";      onClicked: vehicleState.seatbeltWarningActive = !vehicleState.seatbeltWarningActive }
            Button { Layout.fillWidth: true; text: "Check Engine";  onClicked: vehicleState.checkEngineCautionActive = !vehicleState.checkEngineCautionActive }
            Button { Layout.fillWidth: true; text: "Low Fuel";      onClicked: vehicleState.lowFuelCautionActive = !vehicleState.lowFuelCautionActive }
            Button { Layout.fillWidth: true; text: "Tire Pressure"; onClicked: vehicleState.tirePressCautionActive = !vehicleState.tirePressCautionActive }

            // Section header
            Text { Layout.columnSpan: 2; text: "── Info Indicators ──"; color: "white"; font.pixelSize: 11 }

            Button { Layout.fillWidth: true; text: "Cruise Control"; onClicked: vehicleState.cruiseControlActive = !vehicleState.cruiseControlActive }
            Button { Layout.fillWidth: true; text: "Hi-Beams";       onClicked: vehicleState.hiBeamsActive = !vehicleState.hiBeamsActive }
            Button { Layout.columnSpan: 2; Layout.fillWidth: true; text: "Lo-Beams"; onClicked: vehicleState.loBeamsActive = !vehicleState.loBeamsActive }

            // Section header
            Text { Layout.columnSpan: 2; text: "── UI Controls ──"; color: "white"; font.pixelSize: 11 }

            Button {
                Layout.columnSpan: 2; Layout.fillWidth: true
                text: "Next Data View"
                onClicked: vehicleState.activeDataIndex = (vehicleState.activeDataIndex + 1) % 3
            }
            Button {
                Layout.columnSpan: 2; Layout.fillWidth: true
                text: "Toggle Theme"
                onClicked: themeService.darkMode = !themeService.darkMode
            }
            Button {
                Layout.columnSpan: 2; Layout.fillWidth: true
                text: "Toggle Units (Metric/Imperial)"
                onClicked: settingsService.metricUnits = !settingsService.metricUnits
            }
            Button {
                Layout.columnSpan: 2; Layout.fillWidth: true
                text: "Toggle Time Format (" + (settingsService.use24HourTime ? "24hr" : "12hr") + ")"
                onClicked: settingsService.use24HourTime = !settingsService.use24HourTime
            }
        }
    }
}