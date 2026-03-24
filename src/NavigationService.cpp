#include "NavigationService.h"
#include "LocationService.h"
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QUrlQuery>
#include <QFile>
#include <QTextStream>
#include <QCoreApplication>
#include <cmath>

NavigationService::NavigationService(QObject *parent) : QObject(parent) {
    loadToken();
}

void NavigationService::setLocationService(LocationService *loc) {
    m_location = loc;
    connect(loc, &LocationService::latitudeChanged,  this, &NavigationService::checkPosition);
    connect(loc, &LocationService::longitudeChanged, this, &NavigationService::checkPosition);
}

void NavigationService::loadToken() {
    const QStringList candidates = {
        QCoreApplication::applicationDirPath() + "/.env",
        QCoreApplication::applicationDirPath() + "/../.env"
    };
    for (const QString &path : candidates) {
        QFile file(path);
        if (!file.open(QIODevice::ReadOnly)) continue;
        QTextStream in(&file);
        while (!in.atEnd()) {
            const QString line = in.readLine().trimmed();
            if (line.isEmpty() || line.startsWith('#')) continue;
            const int eq = line.indexOf('=');
            if (eq < 0) continue;
            if (line.left(eq).trimmed() == "MAPBOX_ACCESS_TOKEN") {
                m_accessToken = line.mid(eq + 1).trimmed();
                return;
            }
        }
    }
}

// ── Search ────────────────────────────────────────────────────────────────────

void NavigationService::searchAddress(const QString &address) {
    if (m_accessToken.isEmpty() || !m_location) return;

    m_isSearching = true;
    emit isSearchingChanged();

    QUrl url(QString("https://api.mapbox.com/geocoding/v5/mapbox.places/%1.json")
                 .arg(QString::fromUtf8(QUrl::toPercentEncoding(address))));
    QUrlQuery q;
    q.addQueryItem("access_token", m_accessToken);
    q.addQueryItem("limit", "1");
    q.addQueryItem("proximity",
        QString("%1,%2").arg(m_location->longitude(), 0, 'f', 6)
                        .arg(m_location->latitude(),  0, 'f', 6));
    url.setQuery(q);

    auto *reply = m_network.get(QNetworkRequest(url));
    connect(reply, &QNetworkReply::finished, this, [this, reply, address]() {
        parseGeocodeReply(reply, address);
        reply->deleteLater();
    });
}

void NavigationService::parseGeocodeReply(QNetworkReply *reply, const QString &destName) {
    m_isSearching = false;
    emit isSearchingChanged();

    if (reply->error() != QNetworkReply::NoError) { emit routeError(reply->errorString()); return; }

    const QJsonArray feats = QJsonDocument::fromJson(reply->readAll())
                                 .object().value("features").toArray();
    if (feats.isEmpty()) { emit routeError("No results for: " + destName); return; }

    const QJsonObject first  = feats.first().toObject();
    const QJsonArray  center = first.value("center").toArray();
    fetchRoute(center[1].toDouble(), center[0].toDouble(),
               first.value("place_name").toString());
}

// ── Route ─────────────────────────────────────────────────────────────────────

void NavigationService::fetchRoute(double toLat, double toLng, const QString &destName) {
    if (m_accessToken.isEmpty() || !m_location) return;

    m_isSearching = true;
    emit isSearchingChanged();
    m_destName = destName;
    emit destNameChanged();

    const QString coords = QString("%1,%2;%3,%4")
        .arg(m_location->longitude(), 0, 'f', 6).arg(m_location->latitude(),  0, 'f', 6)
        .arg(toLng,                   0, 'f', 6).arg(toLat,                    0, 'f', 6);

    QUrl url(QString("https://api.mapbox.com/directions/v5/mapbox/driving-traffic/%1").arg(coords));
    QUrlQuery q;
    q.addQueryItem("access_token",        m_accessToken);
    q.addQueryItem("steps",               "true");
    q.addQueryItem("geometries",          "geojson");
    q.addQueryItem("overview",            "full");
    url.setQuery(q);

    auto *reply = m_network.get(QNetworkRequest(url));
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        parseDirectionsReply(reply);
        reply->deleteLater();
    });
}

void NavigationService::parseDirectionsReply(QNetworkReply *reply) {
    m_isSearching = false;
    emit isSearchingChanged();

    if (reply->error() != QNetworkReply::NoError) { emit routeError(reply->errorString()); return; }

    const QJsonObject root   = QJsonDocument::fromJson(reply->readAll()).object();
    const QJsonArray  routes = root.value("routes").toArray();
    if (routes.isEmpty()) { emit routeError("No route found"); return; }

    const QJsonObject route = routes.first().toObject();

    // Full geometry → map line
    m_routePath.clear();
    for (const QJsonValue &c : route.value("geometry").toObject().value("coordinates").toArray()) {
        const QJsonArray pt = c.toArray();
        QVariantMap coord;
        coord["longitude"] = pt[0].toDouble();
        coord["latitude"]  = pt[1].toDouble();
        m_routePath.append(coord);
    }
    emit routePathChanged();

    // Steps → directions panel list + step advancement data
    m_steps.clear();
    m_totalDurationS = 0;
    double totalDistM = 0;

    for (const QJsonValue &legVal : route.value("legs").toArray()) {
        for (const QJsonValue &stepVal : legVal.toObject().value("steps").toArray()) {
            const QJsonObject stepObj  = stepVal.toObject();
            const QJsonObject maneuver = stepObj.value("maneuver").toObject();
            const QJsonArray  loc      = maneuver.value("location").toArray();
            const double      distM    = stepObj.value("distance").toDouble();
            const double      durS     = stepObj.value("duration").toDouble();

            QVariantMap s;
            s["instruction"]  = maneuver.value("instruction").toString();
            s["type"]         = maneuver.value("type").toString();
            s["modifier"]     = maneuver.value("modifier").toString();
            s["distanceText"] = formatDistance(distM);
            s["endLng"]       = loc[0].toDouble();
            s["endLat"]       = loc[1].toDouble();
            m_steps.append(s);

            m_totalDurationS += durS;
            totalDistM       += distM;
        }
    }

    m_etaText       = formatDuration(m_totalDurationS);
    m_totalDistText = formatDistance(totalDistM);
    emit stepsChanged();
    emit etaTextChanged();
    emit totalDistTextChanged();

    m_currentStep = 0;
    emit routeReady();
}

// ── Navigation state ──────────────────────────────────────────────────────────

void NavigationService::startNavigation() {
    if (m_steps.isEmpty()) return;
    m_isNavigating = true;
    m_currentStep  = 0;
    updateStepDisplay();
    emit isNavigatingChanged();
    emit currentStepChanged();
}

void NavigationService::stopNavigation() {
    m_isNavigating  = false;
    m_currentStep   = 0;
    m_instruction   = "";
    m_distanceText  = "";
    m_etaText       = "";
    m_totalDistText = "";
    m_destName      = "";
    m_steps.clear();
    m_routePath.clear();
    emit isNavigatingChanged();
    emit routePathChanged();
    emit stepsChanged();
    emit instructionChanged();
    emit distanceTextChanged();
    emit etaTextChanged();
    emit totalDistTextChanged();
    emit destNameChanged();
}

// ── GPS-driven step advancement ───────────────────────────────────────────────

void NavigationService::checkPosition() {
    if (!m_isNavigating || m_steps.isEmpty() || !m_location) return;

    // Advance when within 30 m of the NEXT step's maneuver point
    const int nextIdx = m_currentStep + 1;
    if (nextIdx >= m_steps.size()) return;

    const QVariantMap &next = m_steps[nextIdx].toMap();
    const double latRad = m_location->latitude() * M_PI / 180.0;
    const double dLat   = (next["endLat"].toDouble() - m_location->latitude())  * 111111.0;
    const double dLon   = (next["endLng"].toDouble() - m_location->longitude()) * 111111.0 * std::cos(latRad);

    if (std::sqrt(dLat * dLat + dLon * dLon) < 30.0) {
        m_currentStep++;
        emit currentStepChanged();
        updateStepDisplay();

        if (m_currentStep >= m_steps.size() - 1)
            stopNavigation();
    }
}

void NavigationService::updateStepDisplay() {
    if (m_steps.isEmpty() || m_currentStep >= m_steps.size()) return;
    const QVariantMap &step = m_steps[m_currentStep].toMap();
    m_instruction  = step["instruction"].toString();
    m_distanceText = step["distanceText"].toString();

    double remainingS = 0;
    for (int i = m_currentStep; i < m_steps.size(); ++i)
        remainingS += m_steps[i].toMap()["durationS"].toDouble();
    m_etaText = formatDuration(remainingS);

    emit instructionChanged();
    emit distanceTextChanged();
    emit etaTextChanged();
}

// ── Helpers ───────────────────────────────────────────────────────────────────

QString NavigationService::formatDistance(double meters) const {
    if (meters < 1000) return QString("%1 m").arg(static_cast<int>(meters / 10) * 10);
    return QString("%1 km").arg(meters / 1000.0, 0, 'f', 1);
}

QString NavigationService::formatDuration(double seconds) const {
    const int mins = qRound(seconds / 60.0);
    if (mins < 60) return QString("%1 min").arg(mins);
    return QString("%1 h %2 min").arg(mins / 60).arg(mins % 60);
}
