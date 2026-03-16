// Created by chris on 3/15/26.
#pragma once
#include <QObject>

class ClimateService : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int   fanSpeed    READ fanSpeed    WRITE setFanSpeed    NOTIFY fanSpeedChanged)
    Q_PROPERTY(qreal temperature READ temperature WRITE setTemperature NOTIFY temperatureChanged)  // °F
    Q_PROPERTY(int   ductMode    READ ductMode    WRITE setDuctMode    NOTIFY ductModeChanged)     // 0–7

public:
    explicit ClimateService(QObject *parent = nullptr) : QObject(parent) {}

    int   fanSpeed()    const { return m_fanSpeed; }
    qreal temperature() const { return m_temperature; }
    int   ductMode()    const { return m_ductMode; }

public slots:
    void setFanSpeed(int v)      { if (m_fanSpeed    != v) { m_fanSpeed    = v; emit fanSpeedChanged(); } }
    void setTemperature(qreal v) { if (m_temperature != v) { m_temperature = v; emit temperatureChanged(); } }
    void setDuctMode(int v)      { if (m_ductMode    != v) { m_ductMode    = v; emit ductModeChanged(); } }

signals:
    void fanSpeedChanged();
    void temperatureChanged();
    void ductModeChanged();

private:
    int   m_fanSpeed    = 1;    // 1–4 speed levels
    qreal m_temperature = 22.0; // °C, 15–32 range
    int   m_ductMode    = 0;    // 0=Vents 1=Vents+Floor 2=Defrost 3=Defrost+Floor
                                // 4=Floor 5=A/C 6=Max A/C 7=Off
};
