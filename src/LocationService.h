//
// Created by chris on 3/7/26.
//
#pragma once
#include <QObject>

class LocationService : public QObject
{
    Q_OBJECT

    Q_PROPERTY(qreal localSpeedLimit READ localSpeedLimit WRITE setLocalSpeedLimit NOTIFY localSpeedLimitChanged)
    Q_PROPERTY(qreal latitude READ latitude WRITE setLatitude NOTIFY latitudeChanged)
    Q_PROPERTY(qreal longitude READ longitude WRITE setLongitude NOTIFY longitudeChanged)
    Q_PROPERTY(QString sunriseTime READ sunriseTime WRITE setSunriseTime NOTIFY sunriseTimeChanged)
    Q_PROPERTY(QString sunsetTime READ sunsetTime WRITE setSunsetTime NOTIFY sunsetTimeChanged)
    Q_PROPERTY(qreal outsideTemp READ outsideTemp WRITE setOutsideTemp NOTIFY outsideTempChanged)  // °C; -999 = no data
    Q_PROPERTY(qreal heading READ heading WRITE setHeading NOTIFY headingChanged)  // degrees, 0=North, clockwise

public:
    explicit LocationService(QObject *parent = nullptr);

    qreal localSpeedLimit() const { return m_localSpeedLimit; }
    qreal latitude() const { return m_latitude; }
    qreal longitude() const { return m_longitude; }
    QString sunriseTime() const { return m_sunriseTime; }
    QString sunsetTime() const { return m_sunsetTime; }
    qreal outsideTemp() const { return m_outsideTemp; }
    qreal heading()     const { return m_heading; }

public slots:
    void setLocalSpeedLimit(qreal v);
    void setLatitude(qreal v);
    void setLongitude(qreal v);
    void setSunriseTime(const QString &v);
    void setSunsetTime(const QString &v);
    void setOutsideTemp(qreal v);
    void setHeading(qreal v);

    signals:
        void localSpeedLimitChanged();
    void latitudeChanged();
    void longitudeChanged();
    void sunriseTimeChanged();
    void sunsetTimeChanged();
    void outsideTempChanged();
    void headingChanged();

private:
    qreal m_localSpeedLimit = 88.5;
    qreal m_latitude = 32.8407;   // Macon, GA hardcoded for now
    qreal m_longitude = -83.6324;
    QString m_sunriseTime = "06:30";
    QString m_sunsetTime  = "19:45";
    qreal m_outsideTemp   = -999.0;  // °C; -999 = no data yet
    qreal m_heading       = 0.0;     // degrees, 0=North
};