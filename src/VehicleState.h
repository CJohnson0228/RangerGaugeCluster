//
// Created by chris on 3/3/26.
//
#pragma once
#include <QObject>
#include <QProperty>
#include <QString>

class VehicleState : public QObject
{
    Q_OBJECT

    // Tire Pressure (kPa)
    Q_PROPERTY(int tirePressLF READ tirePressLF WRITE setTirePressLF NOTIFY tirePressLFChanged)
    Q_PROPERTY(int tirePressRF READ tirePressRF WRITE setTirePressRF NOTIFY tirePressRFChanged)
    Q_PROPERTY(int tirePressLR READ tirePressLR WRITE setTirePressLR NOTIFY tirePressLRChanged)
    Q_PROPERTY(int tirePressRR READ tirePressRR WRITE setTirePressRR NOTIFY tirePressRRChanged)

    // Speed & Motion
    Q_PROPERTY(qreal vehicleSpeed READ vehicleSpeed WRITE setVehicleSpeed NOTIFY vehicleSpeedChanged)
    Q_PROPERTY(qreal engineRPM READ engineRPM WRITE setEngineRPM NOTIFY engineRPMChanged)

    // Engine
    Q_PROPERTY(qreal engineTemp READ engineTemp WRITE setEngineTemp NOTIFY engineTempChanged)

    // Fuel
    Q_PROPERTY(qreal fuelLevel READ fuelLevel WRITE setFuelLevel NOTIFY fuelLevelChanged)
    Q_PROPERTY(qreal fuelRemaining READ fuelRemaining NOTIFY fuelRemainingChanged)
    Q_PROPERTY(qreal fuelRange READ fuelRange NOTIFY fuelRangeChanged)
    Q_PROPERTY(qreal tankCapacityLiters READ tankCapacityLiters CONSTANT)
    Q_PROPERTY(qreal fuelEconomyLive READ fuelEconomyLive WRITE setFuelEconomyLive NOTIFY fuelEconomyLiveChanged)
    Q_PROPERTY(qreal fuelEconomyAverage READ fuelEconomyAverage WRITE setFuelEconomyAverage NOTIFY fuelEconomyAverageChanged)

    // Distance
    Q_PROPERTY(qreal odometer READ odometer WRITE setOdometer NOTIFY odometerChanged)
    Q_PROPERTY(qreal tripAmileage READ tripAmileage WRITE setTripAmileage NOTIFY tripAmileageChanged)
    Q_PROPERTY(qreal tripBmileage READ tripBmileage WRITE setTripBmileage NOTIFY tripBmileageChanged)

    // Vehicle Controls
    Q_PROPERTY(bool leftTurnActive READ leftTurnActive WRITE setLeftTurnActive NOTIFY leftTurnActiveChanged)
    Q_PROPERTY(bool rightTurnActive READ rightTurnActive WRITE setRightTurnActive NOTIFY rightTurnActiveChanged)
    Q_PROPERTY(int activeDataIndex READ activeDataIndex WRITE setActiveDataIndex NOTIFY activeDataIndexChanged)

    // Warning Indicators
    Q_PROPERTY(bool batteryWarningActive READ batteryWarningActive WRITE setBatteryWarningActive NOTIFY batteryWarningActiveChanged)
    Q_PROPERTY(bool brakeWarningActive READ brakeWarningActive WRITE setBrakeWarningActive NOTIFY brakeWarningActiveChanged)
    Q_PROPERTY(bool coolantTempWarningActive READ coolantTempWarningActive WRITE setCoolantTempWarningActive NOTIFY coolantTempWarningActiveChanged)
    Q_PROPERTY(bool parkingBrakeWarningActive READ parkingBrakeWarningActive WRITE setParkingBrakeWarningActive NOTIFY parkingBrakeWarningActiveChanged)
    Q_PROPERTY(bool oilWarningActive READ oilWarningActive WRITE setOilWarningActive NOTIFY oilWarningActiveChanged)
    Q_PROPERTY(bool seatbeltWarningActive READ seatbeltWarningActive WRITE setSeatbeltWarningActive NOTIFY seatbeltWarningActiveChanged)

    // Caution Indicators
    Q_PROPERTY(bool checkEngineCautionActive READ checkEngineCautionActive WRITE setCheckEngineCautionActive NOTIFY checkEngineCautionActiveChanged)
    Q_PROPERTY(bool lowFuelCautionActive READ lowFuelCautionActive WRITE setLowFuelCautionActive NOTIFY lowFuelCautionActiveChanged)
    Q_PROPERTY(bool tirePressCautionActive READ tirePressCautionActive WRITE setTirePressCautionActive NOTIFY tirePressCautionActiveChanged)

    // Info Indicators
    Q_PROPERTY(bool cruiseControlActive READ cruiseControlActive WRITE setCruiseControlActive NOTIFY cruiseControlActiveChanged)
    Q_PROPERTY(bool hiBeamsActive READ hiBeamsActive WRITE setHiBeamsActive NOTIFY hiBeamsActiveChanged)
    Q_PROPERTY(bool loBeamsActive READ loBeamsActive WRITE setLoBeamsActive NOTIFY loBeamsActiveChanged)

public:
    explicit VehicleState(QObject *parent = nullptr);

    // Tire Pressure (kPa)
    int tirePressLF() const { return m_tirePressLF; }
    int tirePressRF() const { return m_tirePressRF; }
    int tirePressLR() const { return m_tirePressLR; }
    int tirePressRR() const { return m_tirePressRR; }

    // Speed & Motion
    qreal vehicleSpeed() const { return m_vehicleSpeed; }
    qreal engineRPM() const { return m_engineRPM; }

    // Engine
    qreal engineTemp() const { return m_engineTemp; }

    // Fuel
    qreal tankCapacityLiters() const { return 56.8; }
    qreal fuelLevel() const { return m_fuelLevel; }
    qreal fuelRemaining() const { return m_fuelLevel * tankCapacityLiters(); }
    qreal fuelRange() const {
        if (m_fuelEconomyAverage <= 0.0) return 0.0;
        // fuelRemaining in litres, economy in mpg → range in km
        // km = litres * mpg / 2.35214
        return fuelRemaining() * m_fuelEconomyAverage / 2.35214;
    }
    qreal fuelEconomyLive() const { return m_fuelEconomyLive; }
    qreal fuelEconomyAverage() const { return m_fuelEconomyAverage; }

    // Distance
    qreal odometer() const { return m_odometer; }
    qreal tripAmileage() const { return m_tripAmileage; }
    qreal tripBmileage() const { return m_tripBmileage; }

    // Vehicle Controls
    bool leftTurnActive() const { return m_leftTurnActive; }
    bool rightTurnActive() const { return m_rightTurnActive; }
    int activeDataIndex() const { return m_activeDataIndex; }

    // Warning & Caution Indicators
    bool batteryWarningActive() const { return m_batteryWarningActive; }
    bool brakeWarningActive() const { return m_brakeWarningActive; }
    bool coolantTempWarningActive() const { return m_coolantTempWarningActive; }
    bool parkingBrakeWarningActive() const { return m_parkingBrakeWarningActive; }
    bool oilWarningActive() const { return m_oilWarningActive; }
    bool seatbeltWarningActive() const { return m_seatbeltWarningActive; }
    bool checkEngineCautionActive() const { return m_checkEngineCautionActive; }
    bool lowFuelCautionActive() const { return m_lowFuelCautionActive; }
    bool tirePressCautionActive() const { return m_tirePressCautionActive; }

    // Info Indicators
    bool cruiseControlActive() const { return m_cruiseControlActive; }
    bool hiBeamsActive() const { return m_hiBeamsActive; }
    bool loBeamsActive() const { return m_loBeamsActive; }

public slots:
    // Tire Pressure
    void setTirePressLF(int v);
    void setTirePressRF(int v);
    void setTirePressLR(int v);
    void setTirePressRR(int v);

    // Speed & Motion
    void setVehicleSpeed(qreal v);
    void setEngineRPM(qreal v);

    // Engine
    void setEngineTemp(qreal v);

    // Fuel
    void setFuelLevel(qreal v);
    void setFuelEconomyLive(qreal v);
    void setFuelEconomyAverage(qreal v);

    // Distance
    void setOdometer(qreal v);
    void setTripAmileage(qreal v);
    void setTripBmileage(qreal v);

    // Vehicle Controls
    void setLeftTurnActive(bool v);
    void setRightTurnActive(bool v);
    void setActiveDataIndex(int v);

    // Warning & Caution Indicators
    void setBatteryWarningActive(bool v);
    void setBrakeWarningActive(bool v);
    void setCoolantTempWarningActive(bool v);
    void setParkingBrakeWarningActive(bool v);
    void setOilWarningActive(bool v);
    void setSeatbeltWarningActive(bool v);
    void setCheckEngineCautionActive(bool v);
    void setLowFuelCautionActive(bool v);
    void setTirePressCautionActive(bool v);
    void setCruiseControlActive(bool v);
    void setHiBeamsActive(bool v);
    void setLoBeamsActive(bool v);

signals:
    // Tire Pressure
    void tirePressLFChanged();
    void tirePressRFChanged();
    void tirePressLRChanged();
    void tirePressRRChanged();

    // Speed & Motion
    void vehicleSpeedChanged();
    void engineRPMChanged();

    // Engine
    void engineTempChanged();

    // Fuel
    void fuelLevelChanged();
    void fuelRemainingChanged();
    void fuelRangeChanged();
    void fuelEconomyLiveChanged();
    void fuelEconomyAverageChanged();

    // Distance
    void odometerChanged();
    void tripAmileageChanged();
    void tripBmileageChanged();

    // Vehicle Controls
    void leftTurnActiveChanged();
    void rightTurnActiveChanged();
    void activeDataIndexChanged();

    // Warning Indicators
    void batteryWarningActiveChanged();
    void brakeWarningActiveChanged();
    void coolantTempWarningActiveChanged();
    void parkingBrakeWarningActiveChanged();
    void oilWarningActiveChanged();
    void seatbeltWarningActiveChanged();

    // Caution Indicators
    void checkEngineCautionActiveChanged();
    void lowFuelCautionActiveChanged();
    void tirePressCautionActiveChanged();

    // Info Indicators
    void cruiseControlActiveChanged();
    void hiBeamsActiveChanged();
    void loBeamsActiveChanged();

private:
    // Tire Pressure (kPa)
    int m_tirePressLF           = 241;
    int m_tirePressRF           = 241;
    int m_tirePressLR           = 241;
    int m_tirePressRR           = 241;

    // Speed & Motion
    qreal m_vehicleSpeed        = 87.0; // km/h
    qreal m_engineRPM           = 2200.0;

    // Engine (C)
    qreal m_engineTemp          = 91.0;

    // Fuel (level 0–1, economy in mpg)
    qreal m_fuelLevel           = 0.75;
    qreal m_fuelEconomyLive     = 0.0;   // mpg; 0 = engine idle/stopped
    qreal m_fuelEconomyAverage  = 18.7;  // mpg (≈ 12.6 L/100km)

    // Distance (km)
    qreal m_odometer            = 140737.0;
    qreal m_tripAmileage        = 0.0;
    qreal m_tripBmileage        = 0.0;

    // Vehicle Controls
    bool m_leftTurnActive       = false;
    bool m_rightTurnActive      = false;
    int  m_activeDataIndex      = 0;

    // Warning Indicators
    bool m_batteryWarningActive      = false;
    bool m_brakeWarningActive        = false;
    bool m_coolantTempWarningActive  = false;
    bool m_parkingBrakeWarningActive = false;
    bool m_oilWarningActive          = false;
    bool m_seatbeltWarningActive     = false;

    // Caution Indicators
    bool m_checkEngineCautionActive  = false;
    bool m_lowFuelCautionActive      = false;
    bool m_tirePressCautionActive    = false;

    // Info Indicators
    bool m_cruiseControlActive       = false;
    bool m_hiBeamsActive             = false;
    bool m_loBeamsActive             = false;
};