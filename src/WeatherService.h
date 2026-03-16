// Created by chris on 3/15/26.
#pragma once
#include <QObject>
#include <QNetworkAccessManager>
#include <QTimer>

class LocationService;
class QNetworkReply;

class WeatherService : public QObject
{
    Q_OBJECT

    // Current conditions (all raw metric: °C, km/h, mm)
    Q_PROPERTY(double currentTemp    READ currentTemp    WRITE setCurrentTemp    NOTIFY currentTempChanged)
    Q_PROPERTY(double feelsLike      READ feelsLike      WRITE setFeelsLike      NOTIFY feelsLikeChanged)
    Q_PROPERTY(int    weatherCode    READ weatherCode    WRITE setWeatherCode    NOTIFY weatherCodeChanged)
    Q_PROPERTY(double windSpeed      READ windSpeed      WRITE setWindSpeed      NOTIFY windSpeedChanged)
    Q_PROPERTY(int    windDirection  READ windDirection  WRITE setWindDirection  NOTIFY windDirectionChanged)
    Q_PROPERTY(int    humidity       READ humidity       WRITE setHumidity       NOTIFY humidityChanged)
    Q_PROPERTY(double precipitation            READ precipitation            WRITE setPrecipitation            NOTIFY precipitationChanged)
    Q_PROPERTY(int    precipitationProbability READ precipitationProbability WRITE setPrecipitationProbability NOTIFY precipitationProbabilityChanged)

    // Derived / status
    Q_PROPERTY(QString condition READ condition NOTIFY weatherCodeChanged)
    Q_PROPERTY(bool hasData      READ hasData   NOTIFY hasDataChanged)
    Q_PROPERTY(bool loading      READ loading   NOTIFY loadingChanged)

public:
    explicit WeatherService(QObject *parent = nullptr);

    void setLocationService(LocationService *locationService);

    double  currentTemp()   const { return m_currentTemp; }
    double  feelsLike()     const { return m_feelsLike; }
    int     weatherCode()   const { return m_weatherCode; }
    double  windSpeed()     const { return m_windSpeed; }
    int     windDirection() const { return m_windDirection; }
    int     humidity()      const { return m_humidity; }
    double  precipitation()            const { return m_precipitation; }
    int     precipitationProbability() const { return m_precipitationProbability; }
    QString condition()                const;
    bool    hasData()       const { return m_hasData; }
    bool    loading()       const { return m_loading; }

public slots:
    void setCurrentTemp(double v);
    void setFeelsLike(double v);
    void setWeatherCode(int v);
    void setWindSpeed(double v);
    void setWindDirection(int v);
    void setHumidity(int v);
    void setPrecipitation(double v);
    void setPrecipitationProbability(int v);
    void fetchWeather();   // callable from DevPanel for manual refresh

signals:
    void currentTempChanged();
    void feelsLikeChanged();
    void weatherCodeChanged();
    void windSpeedChanged();
    void windDirectionChanged();
    void humidityChanged();
    void precipitationChanged();
    void precipitationProbabilityChanged();
    void hasDataChanged();
    void loadingChanged();

private slots:
    void onLocationChanged();

private:
    void handleReply(QNetworkReply *reply);

    QNetworkAccessManager m_nam;
    QTimer                m_refreshTimer;
    LocationService      *m_locationService = nullptr;

    double m_currentTemp   = -999.0;  // °C; -999 = no data
    double m_feelsLike     = -999.0;
    int    m_weatherCode   = -1;
    double m_windSpeed     = 0.0;     // km/h
    int    m_windDirection = 0;       // degrees
    int    m_humidity      = 0;       // %
    double m_precipitation            = 0.0;  // mm
    int    m_precipitationProbability = 0;    // %

    bool   m_hasData = false;
    bool   m_loading = false;

    double m_lastFetchLat = 0.0;
    double m_lastFetchLon = 0.0;
};
