//
// Created by chris on 3/7/26.
//
#include "UnitsService.h"
#include "VehicleState.h"
#include "LocationService.h"
#include "SettingsService.h"

UnitsService::UnitsService(QObject *parent) : QObject(parent) {}

void UnitsService::setDependencies(VehicleState *vehicle,
                                    LocationService *location,
                                    SettingsService *settings)
{
    m_vehicle  = vehicle;
    m_location = location;
    m_settings = settings;

    // Speed
    connect(m_vehicle,  &VehicleState::vehicleSpeedChanged,       this, &UnitsService::displaySpeedChanged);
    connect(m_location, &LocationService::localSpeedLimitChanged, this, &UnitsService::displaySpeedLimitChanged);

    // Engine
    connect(m_vehicle,  &VehicleState::engineTempChanged,         this, &UnitsService::displayEngineTempChanged);

    // Fuel
    connect(m_vehicle,  &VehicleState::fuelEconomyLiveChanged,    this, &UnitsService::displayFuelEconomyLiveChanged);
    connect(m_vehicle,  &VehicleState::fuelEconomyLiveChanged,    this, &UnitsService::fuelEconomyEfficiencyChanged);
    connect(m_vehicle,  &VehicleState::fuelEconomyAverageChanged, this, &UnitsService::displayFuelEconomyAverageChanged);
    connect(m_vehicle,  &VehicleState::fuelRangeChanged,          this, &UnitsService::displayFuelRangeChanged);

    // Distance
    connect(m_vehicle,  &VehicleState::odometerChanged,           this, &UnitsService::displayOdometerChanged);
    connect(m_vehicle,  &VehicleState::tripAmileageChanged,       this, &UnitsService::displayTripAChanged);
    connect(m_vehicle,  &VehicleState::tripBmileageChanged,       this, &UnitsService::displayTripBChanged);

    // Tire Pressure
    connect(m_vehicle,  &VehicleState::tirePressLFChanged,        this, &UnitsService::displayTirePressLFChanged);
    connect(m_vehicle,  &VehicleState::tirePressRFChanged,        this, &UnitsService::displayTirePressRFChanged);
    connect(m_vehicle,  &VehicleState::tirePressLRChanged,        this, &UnitsService::displayTirePressLRChanged);
    connect(m_vehicle,  &VehicleState::tirePressRRChanged,        this, &UnitsService::displayTirePressRRChanged);

    // Units toggle — re-emit everything when units change
    connect(m_settings, &SettingsService::metricUnitsChanged,     this, &UnitsService::onUnitsChanged);
}

bool UnitsService::isMetric() const
{
    return m_settings && m_settings->metricUnits();
}

void UnitsService::onUnitsChanged()
{
    // Speed
    emit displaySpeedChanged();
    emit displaySpeedLimitChanged();
    emit speedUnitChanged();

    // Engine
    emit displayEngineTempChanged();
    emit tempUnitChanged();

    // Fuel
    emit displayFuelEconomyLiveChanged();
    emit displayFuelEconomyAverageChanged();
    emit displayFuelRangeChanged();
    emit fuelEconomyUnitChanged();
    emit fuelEconomyEfficiencyChanged();

    // Distance
    emit displayOdometerChanged();
    emit displayTripAChanged();
    emit displayTripBChanged();
    emit distanceUnitChanged();

    // Tire Pressure
    emit displayTirePressLFChanged();
    emit displayTirePressRFChanged();
    emit displayTirePressLRChanged();
    emit displayTirePressRRChanged();
    emit tirePressUnitChanged();
}

// Speed
qreal UnitsService::displaySpeed() const
{
    if (!m_vehicle) return 0.0;
    return isMetric() ? m_vehicle->vehicleSpeed()
                      : m_vehicle->vehicleSpeed() * 0.621371;
}

qreal UnitsService::displaySpeedLimit() const
{
    if (!m_location) return 0.0;
    return isMetric() ? m_location->localSpeedLimit()
                      : m_location->localSpeedLimit() * 0.621371;
}

QString UnitsService::speedUnit() const { return isMetric() ? "km/h" : "mph"; }

// Engine
qreal UnitsService::displayEngineTemp() const
{
    if (!m_vehicle) return 0.0;
    return isMetric() ? m_vehicle->engineTemp()
                      : m_vehicle->engineTemp() * 9.0 / 5.0 + 32.0;
}

QString UnitsService::tempUnit() const { return isMetric() ? "°C" : "°F"; }

// Fuel
qreal UnitsService::displayFuelEconomyLive() const
{
    if (!m_vehicle) return 0.0;
    qreal mpg = m_vehicle->fuelEconomyLive();
    if (mpg <= 0.0) return 0.0;
    return isMetric() ? 235.214 / mpg : mpg;
}

qreal UnitsService::displayFuelEconomyAverage() const
{
    if (!m_vehicle) return 0.0;
    qreal mpg = m_vehicle->fuelEconomyAverage();
    if (mpg <= 0.0) return 0.0;
    return isMetric() ? 235.214 / mpg : mpg;
}

qreal UnitsService::displayFuelRange() const
{
    if (!m_vehicle) return 0.0;
    // fuelRange() is already in km
    return isMetric() ? m_vehicle->fuelRange()
                      : m_vehicle->fuelRange() * 0.621371;
}

QString UnitsService::fuelEconomyUnit() const { return isMetric() ? "L/100km" : "mpg"; }

qreal UnitsService::fuelEconomyEfficiency() const
{
    if (!m_vehicle) return 0.0;
    qreal mpg = m_vehicle->fuelEconomyLive();  // stored as mpg; 0 = idle/stopped
    return qBound(0.0, mpg / 30.0, 1.0);
}

// Distance
qreal UnitsService::displayOdometer() const
{
    if (!m_vehicle) return 0.0;
    return isMetric() ? m_vehicle->odometer()
                      : m_vehicle->odometer() * 0.621371;
}

qreal UnitsService::displayTripA() const
{
    if (!m_vehicle) return 0.0;
    return isMetric() ? m_vehicle->tripAmileage()
                      : m_vehicle->tripAmileage() * 0.621371;
}

qreal UnitsService::displayTripB() const
{
    if (!m_vehicle) return 0.0;
    return isMetric() ? m_vehicle->tripBmileage()
                      : m_vehicle->tripBmileage() * 0.621371;
}

QString UnitsService::distanceUnit() const { return isMetric() ? "km" : "mi"; }

// Tire Pressure — stored in kPa, convert to PSI for imperial
qreal UnitsService::displayTirePressLF() const
{
    if (!m_vehicle) return 0.0;
    return isMetric() ? m_vehicle->tirePressLF()
                      : m_vehicle->tirePressLF() * 0.145038;
}

qreal UnitsService::displayTirePressRF() const
{
    if (!m_vehicle) return 0.0;
    return isMetric() ? m_vehicle->tirePressRF()
                      : m_vehicle->tirePressRF() * 0.145038;
}

qreal UnitsService::displayTirePressLR() const
{
    if (!m_vehicle) return 0.0;
    return isMetric() ? m_vehicle->tirePressLR()
                      : m_vehicle->tirePressLR() * 0.145038;
}

qreal UnitsService::displayTirePressRR() const
{
    if (!m_vehicle) return 0.0;
    return isMetric() ? m_vehicle->tirePressRR()
                      : m_vehicle->tirePressRR() * 0.145038;
}

QString UnitsService::tirePressUnit() const { return isMetric() ? "kPa" : "PSI"; }