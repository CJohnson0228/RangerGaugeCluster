//
// Created by chris on 3/7/26.
//
#pragma once
#include <QObject>
#include <QString>

class VehicleState;
class LocationService;
class SettingsService;

class UnitsService : public QObject
{
    Q_OBJECT

    // Speed
    Q_PROPERTY(qreal displaySpeed READ displaySpeed NOTIFY displaySpeedChanged)
    Q_PROPERTY(qreal displaySpeedLimit READ displaySpeedLimit NOTIFY displaySpeedLimitChanged)
    Q_PROPERTY(QString speedUnit READ speedUnit NOTIFY speedUnitChanged)
    Q_PROPERTY(int speedMaxValue READ speedMaxValue NOTIFY speedUnitChanged)
    Q_PROPERTY(int speedTickStep READ speedTickStep NOTIFY speedUnitChanged)

    // Engine
    Q_PROPERTY(qreal displayEngineTemp READ displayEngineTemp NOTIFY displayEngineTempChanged)
    Q_PROPERTY(QString tempUnit READ tempUnit NOTIFY tempUnitChanged)

    // Fuel
    Q_PROPERTY(qreal displayFuelEconomyLive READ displayFuelEconomyLive NOTIFY displayFuelEconomyLiveChanged)
    Q_PROPERTY(qreal displayFuelEconomyAverage READ displayFuelEconomyAverage NOTIFY displayFuelEconomyAverageChanged)
    Q_PROPERTY(qreal displayFuelRange READ displayFuelRange NOTIFY displayFuelRangeChanged)
    Q_PROPERTY(QString fuelEconomyUnit READ fuelEconomyUnit NOTIFY fuelEconomyUnitChanged)
    Q_PROPERTY(qreal fuelEconomyMax READ fuelEconomyMax NOTIFY fuelEconomyUnitChanged)
    Q_PROPERTY(qreal fuelEconomyEfficiency READ fuelEconomyEfficiency NOTIFY fuelEconomyEfficiencyChanged)

    // Distance
    Q_PROPERTY(qreal displayOdometer READ displayOdometer NOTIFY displayOdometerChanged)
    Q_PROPERTY(qreal displayTripA READ displayTripA NOTIFY displayTripAChanged)
    Q_PROPERTY(qreal displayTripB READ displayTripB NOTIFY displayTripBChanged)
    Q_PROPERTY(QString distanceUnit READ distanceUnit NOTIFY distanceUnitChanged)

    // Tire Pressure
    Q_PROPERTY(qreal displayTirePressLF READ displayTirePressLF NOTIFY displayTirePressLFChanged)
    Q_PROPERTY(qreal displayTirePressRF READ displayTirePressRF NOTIFY displayTirePressRFChanged)
    Q_PROPERTY(qreal displayTirePressLR READ displayTirePressLR NOTIFY displayTirePressLRChanged)
    Q_PROPERTY(qreal displayTirePressRR READ displayTirePressRR NOTIFY displayTirePressRRChanged)
    Q_PROPERTY(QString tirePressUnit READ tirePressUnit NOTIFY tirePressUnitChanged)
    Q_PROPERTY(int tirePressLowThreshold READ tirePressLowThreshold NOTIFY tirePressUnitChanged)
    Q_PROPERTY(int tirePressHighThreshold READ tirePressHighThreshold NOTIFY tirePressUnitChanged)

public:
    explicit UnitsService(QObject *parent = nullptr);

    void setDependencies(VehicleState *vehicle,
                         LocationService *location,
                         SettingsService *settings);

    // Speed
    qreal displaySpeed() const;
    qreal displaySpeedLimit() const;
    QString speedUnit() const;
    int speedMaxValue() const { return isMetric() ? 200 : 120; }
    int speedTickStep() const { return isMetric() ? 10 : 5; }

    // Engine
    qreal displayEngineTemp() const;
    QString tempUnit() const;

    // Fuel
    qreal displayFuelEconomyLive() const;
    qreal displayFuelEconomyAverage() const;
    qreal displayFuelRange() const;
    QString fuelEconomyUnit() const;
    qreal fuelEconomyMax() const { return 30.0; }  // bar always linear in mpg
    qreal fuelEconomyEfficiency() const;

    // Distance
    qreal displayOdometer() const;
    qreal displayTripA() const;
    qreal displayTripB() const;
    QString distanceUnit() const;

    // Tire Pressure
    qreal displayTirePressLF() const;
    qreal displayTirePressRF() const;
    qreal displayTirePressLR() const;
    qreal displayTirePressRR() const;
    QString tirePressUnit() const;
    int tirePressLowThreshold() const  { return isMetric() ? 180 : 26; }
    int tirePressHighThreshold() const { return isMetric() ? 300 : 44; }

signals:
    // Speed
    void displaySpeedChanged();
    void displaySpeedLimitChanged();
    void speedUnitChanged();

    // Engine
    void displayEngineTempChanged();
    void tempUnitChanged();

    // Fuel
    void displayFuelEconomyLiveChanged();
    void displayFuelEconomyAverageChanged();
    void displayFuelRangeChanged();
    void fuelEconomyUnitChanged();
    void fuelEconomyEfficiencyChanged();

    // Distance
    void displayOdometerChanged();
    void displayTripAChanged();
    void displayTripBChanged();
    void distanceUnitChanged();

    // Tire Pressure
    void displayTirePressLFChanged();
    void displayTirePressRFChanged();
    void displayTirePressLRChanged();
    void displayTirePressRRChanged();
    void tirePressUnitChanged();

private slots:
    void onUnitsChanged();

private:
    bool isMetric() const;

    VehicleState    *m_vehicle   = nullptr;
    LocationService *m_location  = nullptr;
    SettingsService *m_settings  = nullptr;
};