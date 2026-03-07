//
// Created by chris on 3/3/26.
//

#include "VehicleState.h"

VehicleState::VehicleState(QObject *parent) : QObject(parent) {}

void VehicleState::setTirePressLF(int v) { if (m_tirePressLF != v) { m_tirePressLF = v; emit tirePressLFChanged(); } }
void VehicleState::setTirePressRF(int v) { if (m_tirePressRF != v) { m_tirePressRF = v; emit tirePressRFChanged(); } }
void VehicleState::setTirePressLR(int v) { if (m_tirePressLR != v) { m_tirePressLR = v; emit tirePressLRChanged(); } }
void VehicleState::setTirePressRR(int v) { if (m_tirePressRR != v) { m_tirePressRR = v; emit tirePressRRChanged(); } }
void VehicleState::setVehicleSpeed(qreal v) { if (m_vehicleSpeed != v) { m_vehicleSpeed = v; emit vehicleSpeedChanged(); } }
void VehicleState::setFuelGallonsRemaining(qreal v) {
    if (m_fuelGallonsRemaining != v) {
        m_fuelGallonsRemaining = v;
        emit fuelGallonsRemainingChanged();
        emit fuelLevelChanged();      // computed property depends on this
        emit fuelRangeLeftChanged();  // computed property depends on this
    }
}

void VehicleState::setEngineTemp(qreal v) {
    if (m_engineTemp != v) {
        m_engineTemp = v;
        emit engineTempChanged();
        emit engineTempLevelChanged(); // computed property depends on this
    }
}

void VehicleState::setOdometer(qreal v) { if (m_odometer != v) { m_odometer = v; emit odometerChanged(); } }
void VehicleState::setLocalSpeedLimit(qreal v) { if (m_localSpeedLimit != v) { m_localSpeedLimit = v; emit localSpeedLimitChanged(); } }
void VehicleState::setEngineRPM(qreal v) { if (m_engineRPM != v) { m_engineRPM = v; emit engineRPMChanged(); } }
void VehicleState::setFuelEconomyLive(qreal v) { if (m_fuelEconomyLive != v) { m_fuelEconomyLive = v; emit fuelEconomyLiveChanged(); } }
void VehicleState::setFuelEconomyAverage(qreal v) { if (m_fuelEconomyAverage != v) { m_fuelEconomyAverage = v; emit fuelEconomyAverageChanged(); } }
void VehicleState::setTripAmileage(qreal v) { if (m_tripAmileage != v) { m_tripAmileage = v; emit tripAmileageChanged(); } }
void VehicleState::setTripBmileage(qreal v) { if (m_tripBmileage != v) { m_tripBmileage = v; emit tripBmileageChanged(); } }
void VehicleState::setLeftTurnActive(bool v) { if (m_leftTurnActive != v) { m_leftTurnActive = v; emit leftTurnActiveChanged(); } }
void VehicleState::setRightTurnActive(bool v) { if (m_rightTurnActive != v) { m_rightTurnActive = v; emit rightTurnActiveChanged(); } }
void VehicleState::setActiveDataIndex(int v) { if (m_activeDataIndex != v) { m_activeDataIndex = v; emit activeDataIndexChanged(); } }
void VehicleState::setMediaSourceImage(const QString &v) { if (m_mediaSourceImage != v) { m_mediaSourceImage = v; emit mediaSourceImageChanged(); } }
void VehicleState::setMediaBandName(const QString &v) { if (m_mediaBandName != v) { m_mediaBandName = v; emit mediaBandNameChanged(); } }
void VehicleState::setMediaSongName(const QString &v) { if (m_mediaSongName != v) { m_mediaSongName = v; emit mediaSongNameChanged(); } }
void VehicleState::setDarkMode(bool v) { if (m_darkMode != v) { m_darkMode = v; emit darkModeChanged(); } }

void VehicleState::setBatteryWarningActive(bool v) { if (m_batteryWarningActive != v) { m_batteryWarningActive = v; emit batteryWarningActiveChanged(); } }
void VehicleState::setBrakeWarningActive(bool v) { if (m_brakeWarningActive != v) { m_brakeWarningActive = v; emit brakeWarningActiveChanged(); } }
void VehicleState::setCoolantTempWarningActive(bool v) { if (m_coolantTempWarningActive != v) { m_coolantTempWarningActive = v; emit coolantTempWarningActiveChanged(); } }
void VehicleState::setParkingBrakeWarningActive(bool v) { if (m_parkingBrakeWarningActive != v) { m_parkingBrakeWarningActive = v; emit parkingBrakeWarningActiveChanged(); } }
void VehicleState::setOilWarningActive(bool v) { if (m_oilWarningActive != v) { m_oilWarningActive = v; emit oilWarningActiveChanged(); } }
void VehicleState::setCheckEngineCautionActive(bool v) { if (m_checkEngineCautionActive != v) { m_checkEngineCautionActive = v; emit checkEngineCautionActiveChanged(); } }
void VehicleState::setLowFuelCautionActive(bool v) { if (m_lowFuelCautionActive != v) { m_lowFuelCautionActive = v; emit lowFuelCautionActiveChanged(); } }
void VehicleState::setTirePressCautionActive(bool v) { if (m_tirePressCautionActive != v) { m_tirePressCautionActive = v; emit tirePressCautionActiveChanged(); } }
void VehicleState::setSeatbeltWarningActive(bool v) { if (m_seatbeltWarningActive != v) { m_seatbeltWarningActive = v; emit seatbeltWarningActiveChanged(); } }
