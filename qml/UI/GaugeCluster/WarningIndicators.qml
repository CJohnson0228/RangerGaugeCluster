import QtQuick
import QtQuick.Layouts
import HMItestUI

RowLayout {
    anchors.centerIn: parent
    spacing: 20

    // Battery Warning (warning)
    WarningIndicator {
        active: vehicleState.batteryWarningActive
        warning: true
        iconSource: "batterywarning.svg"
    }
    // Brake Warning (warning)
    WarningIndicator {
        active: vehicleState.brakeWarningActive
        warning: true
        iconSource: "brakewarning.svg"
    }
    // Coolant Temp Warning (warning)
    WarningIndicator {
        active: vehicleState.coolantTempWarningActive
        warning: true
        iconSource: "coolanttempwarning.svg"
    }
    // Parking Brake (warning)
    WarningIndicator {
        active: vehicleState.parkingBrakeWarningActive
        warning: true
        iconSource: "parkwarning.svg"
    }
    // Oil Warning (warning)
    WarningIndicator {
        active: vehicleState.oilWarningActive
        warning: true
        iconSource: "oilwarning.svg"
    }
    // Seatbelt Warning (warning)
    WarningIndicator {
        active: vehicleState.seatbeltWarningActive
        warning: true
        iconSource: "seatbeltwarning.svg"
    }
    // Check Engine (caution)
    WarningIndicator {
        active: vehicleState.checkEngineCautionActive
        warning: false
        iconSource: "checkengine.svg"
    }
    // Low Fuel (caution)
    WarningIndicator {
        active: vehicleState.lowFuelCautionActive
        warning: false
        iconSource: "fuellow.svg"
    }
    // Tire Pressure (caution)
    WarningIndicator {
        active: vehicleState.tirePressCautionActive
        warning: false
        iconSource: "tirepresswarning.svg"
    }
}