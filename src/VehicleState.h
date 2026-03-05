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

    // Vehicle General
    Q_PROPERTY(int tirePressLF READ tirePressLF WRITE setTirePressLF NOTIFY tirePressLFChanged)
    Q_PROPERTY(int tirePressRF READ tirePressRF WRITE setTirePressRF NOTIFY tirePressRFChanged)
    Q_PROPERTY(int tirePressLR READ tirePressLR WRITE setTirePressLR NOTIFY tirePressLRChanged)
    Q_PROPERTY(int tirePressRR READ tirePressRR WRITE setTirePressRR NOTIFY tirePressRRChanged)
    Q_PROPERTY(qreal vehicleSpeed READ vehicleSpeed WRITE setVehicleSpeed NOTIFY vehicleSpeedChanged)
    Q_PROPERTY(qreal engineRPM READ engineRPM WRITE setEngineRPM NOTIFY engineRPMChanged)
    Q_PROPERTY(qreal fuelEconomyLive READ fuelEconomyLive WRITE setFuelEconomyLive NOTIFY fuelEconomyLiveChanged)
    Q_PROPERTY(qreal fuelEconomyAverage READ fuelEconomyAverage WRITE setFuelEconomyAverage NOTIFY fuelEconomyAverageChanged)
    Q_PROPERTY(qreal tripAmileage READ tripAmileage WRITE setTripAmileage NOTIFY tripAmileageChanged)
    Q_PROPERTY(qreal tripBmileage READ tripBmileage WRITE setTripBmileage NOTIFY tripBmileageChanged)
    Q_PROPERTY(bool leftTurnActive READ leftTurnActive WRITE setLeftTurnActive NOTIFY leftTurnActiveChanged)
    Q_PROPERTY(bool rightTurnActive READ rightTurnActive WRITE setRightTurnActive NOTIFY rightTurnActiveChanged)
    Q_PROPERTY(int activeDataIndex READ activeDataIndex WRITE setActiveDataIndex NOTIFY activeDataIndexChanged)

    // Vehicle Warning Indicators
    Q_PROPERTY(bool batteryWarningActive READ batteryWarningActive WRITE setBatteryWarningActive NOTIFY batteryWarningActiveChanged)
    Q_PROPERTY(bool brakeWarningActive READ brakeWarningActive WRITE setBrakeWarningActive NOTIFY brakeWarningActiveChanged)
    Q_PROPERTY(bool coolantTempWarningActive READ coolantTempWarningActive WRITE setCoolantTempWarningActive NOTIFY coolantTempWarningActiveChanged)
    Q_PROPERTY(bool parkingBrakeWarningActive READ parkingBrakeWarningActive WRITE setParkingBrakeWarningActive NOTIFY parkingBrakeWarningActiveChanged)
    Q_PROPERTY(bool oilWarningActive READ oilWarningActive WRITE setOilWarningActive NOTIFY oilWarningActiveChanged)
    Q_PROPERTY(bool checkEngineCautionActive READ checkEngineCautionActive WRITE setCheckEngineCautionActive NOTIFY checkEngineCautionActiveChanged)
    Q_PROPERTY(bool lowFuelCautionActive READ lowFuelCautionActive WRITE setLowFuelCautionActive NOTIFY lowFuelCautionActiveChanged)
    Q_PROPERTY(bool tirePressCautionActive READ tirePressCautionActive WRITE setTirePressCautionActive NOTIFY tirePressCautionActiveChanged)

    // Media (temporary until MediaService)
    Q_PROPERTY(QString mediaSourceImage READ mediaSourceImage WRITE setMediaSourceImage NOTIFY mediaSourceImageChanged)
    Q_PROPERTY(QString mediaBandName READ mediaBandName WRITE setMediaBandName NOTIFY mediaBandNameChanged)
    Q_PROPERTY(QString mediaSongName READ mediaSongName WRITE setMediaSongName NOTIFY mediaSongNameChanged)

    // Theme
    Q_PROPERTY(bool darkMode READ darkMode WRITE setDarkMode NOTIFY darkModeChanged)

public:
    explicit VehicleState(QObject *parent = nullptr);

    // Getters
    int tirePressLF() const { return m_tirePressLF; }
    int tirePressRF() const { return m_tirePressRF; }
    int tirePressLR() const { return m_tirePressLR; }
    int tirePressRR() const { return m_tirePressRR; }
    qreal vehicleSpeed() const { return m_vehicleSpeed; }
    qreal engineRPM() const { return m_engineRPM; }
    qreal fuelEconomyLive() const { return m_fuelEconomyLive; }
    qreal fuelEconomyAverage() const { return m_fuelEconomyAverage; }
    qreal tripAmileage() const { return m_tripAmileage; }
    qreal tripBmileage() const { return m_tripBmileage; }
    bool leftTurnActive() const { return m_leftTurnActive; }
    bool rightTurnActive() const { return m_rightTurnActive; }
    int activeDataIndex() const { return m_activeDataIndex; }
    QString mediaSourceImage() const { return m_mediaSourceImage; }
    QString mediaBandName() const { return m_mediaBandName; }
    QString mediaSongName() const { return m_mediaSongName; }
    bool darkMode() const { return m_darkMode; }
    bool batteryWarningActive() const { return m_batteryWarningActive; }
    bool brakeWarningActive() const { return m_brakeWarningActive; }
    bool coolantTempWarningActive() const { return m_coolantTempWarningActive; }
    bool parkingBrakeWarningActive() const { return m_parkingBrakeWarningActive; }
    bool oilWarningActive() const { return m_oilWarningActive; }
    bool checkEngineCautionActive() const { return m_checkEngineCautionActive; }
    bool lowFuelCautionActive() const { return m_lowFuelCautionActive; }
    bool tirePressCautionActive() const { return m_tirePressCautionActive; }

    // Setters
public slots:
    void setTirePressLF(int v);
    void setTirePressRF(int v);
    void setTirePressLR(int v);
    void setTirePressRR(int v);
    void setVehicleSpeed(qreal v);
    void setEngineRPM(qreal v);
    void setFuelEconomyLive(qreal v);
    void setFuelEconomyAverage(qreal v);
    void setTripAmileage(qreal v);
    void setTripBmileage(qreal v);
    void setLeftTurnActive(bool v);
    void setRightTurnActive(bool v);
    void setBatteryWarningActive(bool v);
    void setBrakeWarningActive(bool v);
    void setCoolantTempWarningActive(bool v);
    void setParkingBrakeWarningActive(bool v);
    void setOilWarningActive(bool v);
    void setCheckEngineCautionActive(bool v);
    void setLowFuelCautionActive(bool v);
    void setTirePressCautionActive(bool v);
    void setActiveDataIndex(int v);
    void setMediaSourceImage(const QString &v);
    void setMediaBandName(const QString &v);
    void setMediaSongName(const QString &v);
    void setDarkMode(bool v);

signals:
    void tirePressLFChanged();
    void tirePressRFChanged();
    void tirePressLRChanged();
    void tirePressRRChanged();
    void vehicleSpeedChanged();
    void engineRPMChanged();
    void fuelEconomyLiveChanged();
    void fuelEconomyAverageChanged();
    void tripAmileageChanged();
    void tripBmileageChanged();
    void leftTurnActiveChanged();
    void rightTurnActiveChanged();
    void activeDataIndexChanged();
    void mediaSourceImageChanged();
    void mediaBandNameChanged();
    void mediaSongNameChanged();
    void darkModeChanged();
    void batteryWarningActiveChanged();
    void brakeWarningActiveChanged();
    void coolantTempWarningActiveChanged();
    void parkingBrakeWarningActiveChanged();
    void oilWarningActiveChanged();
    void checkEngineCautionActiveChanged();
    void lowFuelCautionActiveChanged();
    void tirePressCautionActiveChanged();

private:
    int m_tirePressLF = 32;
    int m_tirePressRF = 32;
    int m_tirePressLR = 32;
    int m_tirePressRR = 32;
    qreal m_vehicleSpeed = 54.0;
    qreal m_engineRPM = 2200.0;
    qreal m_fuelEconomyLive = 0.0;
    qreal m_fuelEconomyAverage = 18.6;
    qreal m_tripAmileage = 0.0;
    qreal m_tripBmileage = 0.0;
    bool m_leftTurnActive = false;
    bool m_rightTurnActive = false;
    bool m_batteryWarningActive = false;
    bool m_brakeWarningActive = false;
    bool m_coolantTempWarningActive = false;
    bool m_parkingBrakeWarningActive = false;
    bool m_oilWarningActive = false;
    bool m_checkEngineCautionActive = false;
    bool m_lowFuelCautionActive = false;
    bool m_tirePressCautionActive = false;
    int m_activeDataIndex = 0;
    QString m_mediaSourceImage = "tool.jpg";
    QString m_mediaBandName = "Tool";
    QString m_mediaSongName = "Sober";
    bool m_darkMode = true;
};