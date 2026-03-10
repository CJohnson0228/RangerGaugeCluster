import QtQuick
import QtQuick.Layouts
import HMItestUI

RowLayout {
    anchors.centerIn: parent
    spacing: 20

    // Battery Warning
    WarningIndicator {
        active: vehicleState.batteryWarningActive
        indicatorType: "warning"
        iconSource: "batterywarning.svg"
    }
    // Brake Warning
    WarningIndicator {
        active: vehicleState.brakeWarningActive
        indicatorType: "warning"
        iconSource: "brakewarning.svg"
    }
    // Coolant Temp Warning
    WarningIndicator {
        active: vehicleState.coolantTempWarningActive
        indicatorType: "warning"
        iconSource: "coolanttempwarning.svg"
    }
    // Parking Brake Warning
    WarningIndicator {
        active: vehicleState.parkingBrakeWarningActive
        indicatorType: "warning"
        iconSource: "parkwarning.svg"
    }
    // Oil Warning
    WarningIndicator {
        active: vehicleState.oilWarningActive
        indicatorType: "warning"
        iconSource: "oilwarning.svg"
    }
    // Seatbelt Warning
    WarningIndicator {
        active: vehicleState.seatbeltWarningActive
        indicatorType: "warning"
        iconSource: "seatbeltwarning.svg"
    }
    // Check Engine (caution)
    WarningIndicator {
        active: vehicleState.checkEngineCautionActive
        indicatorType: "caution"
        iconSource: "checkengine.svg"
    }
    // Low Fuel (caution)
    WarningIndicator {
        active: vehicleState.lowFuelCautionActive
        indicatorType: "caution"
        iconSource: "fuellow.svg"
    }
    // Tire Pressure (caution)
    WarningIndicator {
        active: vehicleState.tirePressCautionActive
        indicatorType: "caution"
        iconSource: "tirepresswarning.svg"
    }
    // Cruise Control (info)
    WarningIndicator {
        active: vehicleState.cruiseControlActive
        indicatorType: "info"
        iconSource: "cruisecontrol.svg"
    }
    // Hi-Beams (info)
    WarningIndicator {
        active: vehicleState.hiBeamsActive
        indicatorType: "info"
        iconSource: "hibeam.svg"
    }
    // Lo-Beams (info)
    WarningIndicator {
        active: vehicleState.loBeamsActive
        indicatorType: "info"
        iconSource: "lobeam.svg"
    }
}