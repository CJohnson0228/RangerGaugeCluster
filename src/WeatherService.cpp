// Created by chris on 3/15/26.
#include "WeatherService.h"
#include "LocationService.h"
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QUrl>
#include <QUrlQuery>
#include <QtMath>

static constexpr int    kRefreshIntervalMs  = 15 * 60 * 1000; // 15 minutes
static constexpr double kMinPositionDeltaDeg = 0.01;          // ~1 km

WeatherService::WeatherService(QObject *parent) : QObject(parent)
{
    m_refreshTimer.setInterval(kRefreshIntervalMs);
    m_refreshTimer.setSingleShot(false);
    connect(&m_refreshTimer, &QTimer::timeout, this, &WeatherService::fetchWeather);
}

void WeatherService::setLocationService(LocationService *locationService)
{
    m_locationService = locationService;
    connect(locationService, &LocationService::latitudeChanged,  this, &WeatherService::onLocationChanged);
    connect(locationService, &LocationService::longitudeChanged, this, &WeatherService::onLocationChanged);
    fetchWeather();
}

void WeatherService::onLocationChanged()
{
    if (!m_locationService) return;
    const double dlat = m_locationService->latitude()  - m_lastFetchLat;
    const double dlon = m_locationService->longitude() - m_lastFetchLon;
    if (qSqrt(dlat * dlat + dlon * dlon) > kMinPositionDeltaDeg)
        fetchWeather();
}

void WeatherService::fetchWeather()
{
    if (!m_locationService) return;

    m_lastFetchLat = m_locationService->latitude();
    m_lastFetchLon = m_locationService->longitude();

    QUrl url("https://api.open-meteo.com/v1/forecast");
    QUrlQuery q;
    q.addQueryItem("latitude",        QString::number(m_lastFetchLat, 'f', 4));
    q.addQueryItem("longitude",       QString::number(m_lastFetchLon, 'f', 4));
    q.addQueryItem("current",         "temperature_2m,apparent_temperature,"
                                      "precipitation,precipitation_probability,"
                                      "weather_code,wind_speed_10m,"
                                      "wind_direction_10m,relative_humidity_2m");
    q.addQueryItem("wind_speed_unit",  "kmh");
    q.addQueryItem("temperature_unit", "celsius");
    url.setQuery(q);

    m_loading = true;
    emit loadingChanged();

    QNetworkReply *reply = m_nam.get(QNetworkRequest(url));
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        handleReply(reply);
    });

    if (!m_refreshTimer.isActive())
        m_refreshTimer.start();
}

void WeatherService::handleReply(QNetworkReply *reply)
{
    reply->deleteLater();
    m_loading = false;
    emit loadingChanged();

    if (reply->error() != QNetworkReply::NoError) {
        qWarning() << "WeatherService: network error:" << reply->errorString();
        return;
    }

    const QJsonObject current =
        QJsonDocument::fromJson(reply->readAll()).object()["current"].toObject();
    if (current.isEmpty()) return;

    setCurrentTemp(current["temperature_2m"].toDouble());
    setFeelsLike(current["apparent_temperature"].toDouble());
    setWeatherCode(current["weather_code"].toInt());
    setWindSpeed(current["wind_speed_10m"].toDouble());
    setWindDirection(current["wind_direction_10m"].toInt());
    setHumidity(current["relative_humidity_2m"].toInt());
    setPrecipitation(current["precipitation"].toDouble());
    setPrecipitationProbability(current["precipitation_probability"].toInt());

    if (!m_hasData) { m_hasData = true; emit hasDataChanged(); }
}

QString WeatherService::condition() const
{
    switch (m_weatherCode) {
    case 0:       return "Clear";
    case 1:       return "Mostly Clear";
    case 2:       return "Partly Cloudy";
    case 3:       return "Overcast";
    case 45: case 48: return "Fog";
    case 51:      return "Light Drizzle";
    case 53:      return "Drizzle";
    case 55:      return "Heavy Drizzle";
    case 61:      return "Light Rain";
    case 63:      return "Rain";
    case 65:      return "Heavy Rain";
    case 71:      return "Light Snow";
    case 73:      return "Snow";
    case 75:      return "Heavy Snow";
    case 77:      return "Snow Grains";
    case 80:      return "Light Showers";
    case 81:      return "Showers";
    case 82:      return "Heavy Showers";
    case 85:      return "Snow Showers";
    case 86:      return "Heavy Snow Showers";
    case 95:      return "Thunderstorm";
    case 96: case 99: return "T-Storm w/ Hail";
    default:      return m_hasData ? "Unknown" : "--";
    }
}

// ── Setters ──────────────────────────────────────────────────────────────────
void WeatherService::setCurrentTemp(double v)   { if (m_currentTemp   != v) { m_currentTemp   = v; emit currentTempChanged(); } }
void WeatherService::setFeelsLike(double v)     { if (m_feelsLike     != v) { m_feelsLike     = v; emit feelsLikeChanged(); } }
void WeatherService::setWeatherCode(int v)      { if (m_weatherCode   != v) { m_weatherCode   = v; emit weatherCodeChanged(); } }
void WeatherService::setWindSpeed(double v)     { if (m_windSpeed     != v) { m_windSpeed     = v; emit windSpeedChanged(); } }
void WeatherService::setWindDirection(int v)    { if (m_windDirection != v) { m_windDirection = v; emit windDirectionChanged(); } }
void WeatherService::setHumidity(int v)         { if (m_humidity      != v) { m_humidity      = v; emit humidityChanged(); } }
void WeatherService::setPrecipitation(double v)            { if (m_precipitation            != v) { m_precipitation            = v; emit precipitationChanged(); } }
void WeatherService::setPrecipitationProbability(int v)    { if (m_precipitationProbability != v) { m_precipitationProbability = v; emit precipitationProbabilityChanged(); } }
