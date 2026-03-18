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

NavigationService::NavigationService(QObject *parent) : QObject(parent) {
    loadToken();
}

void NavigationService::setLocationService(LocationService *loc) {
    m_location = loc;
}

void NavigationService::loadToken() {
    QStringList candidates = {
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
            if (eq == -1) continue;
            if (line.left(eq).trimmed() == "MAPBOX_ACCESS_TOKEN") {
                m_accessToken = line.mid(eq + 1).trimmed();
                return;
            }
        }
    }
    qWarning() << "NavigationService: MAPBOX_ACCESS_TOKEN not found in .env";
}

void NavigationService::searchAddress(const QString &address) {
    if (m_accessToken.isEmpty() || !m_location) return;

    m_isSearching = true;
    emit isSearchingChanged();

    const QString encoded = QUrl::toPercentEncoding(address);
    QUrl url(QString("https://api.mapbox.com/geocoding/v5/mapbox.places/%1.json").arg(encoded));

    QUrlQuery query;
    query.addQueryItem("access_token", m_accessToken);
    query.addQueryItem("limit", "1");
    query.addQueryItem("proximity",
        QString("%1,%2").arg(m_location->longitude(), 0, 'f', 6)
                        .arg(m_location->latitude(),  0, 'f', 6));
    url.setQuery(query);

    QNetworkReply *reply = m_network.get(QNetworkRequest(url));
    connect(reply, &QNetworkReply::finished, this, [this, reply, address]() {
        parseGeocodeReply(reply, address);
        reply->deleteLater();
    });
}

void NavigationService::parseGeocodeReply(QNetworkReply *reply, const QString &destName) {
    if (reply->error() != QNetworkReply::NoError) {
        m_isSearching = false;
        emit isSearchingChanged();
        emit routeError(reply->errorString());
        return;
    }

    const QJsonDocument doc  = QJsonDocument::fromJson(reply->readAll());
    const QJsonArray    feats = doc.object().value("features").toArray();
    if (feats.isEmpty()) {
        m_isSearching = false;
        emit isSearchingChanged();
        emit routeError("No results for: " + destName);
        return;
    }

    const QJsonArray center = feats.first().toObject().value("center").toArray();
    const double toLng = center[0].toDouble();
    const double toLat = center[1].toDouble();
    const QString placeName = feats.first().toObject().value("place_name").toString();

    // isSearching stays true — fetchRoute will update it
    fetchRoute(toLat, toLng, placeName);
}

void NavigationService::fetchRoute(double toLat, double toLng, const QString &destName) {
    if (m_accessToken.isEmpty() || !m_location) return;

    m_isSearching = true;
    emit isSearchingChanged();

    m_destName = destName;
    emit destNameChanged();

    const QString coords = QString("%1,%2;%3,%4")
        .arg(m_location->longitude(), 0, 'f', 6)
        .arg(m_location->latitude(),  0, 'f', 6)
        .arg(toLng, 0, 'f', 6)
        .arg(toLat, 0, 'f', 6);

    QUrl url(QString("https://api.mapbox.com/directions/v5/mapbox/driving-traffic/%1").arg(coords));
    QUrlQuery query;
    query.addQueryItem("access_token", m_accessToken);
    query.addQueryItem("steps", "true");
    query.addQueryItem("banner_instructions", "true");
    query.addQueryItem("geometries", "geojson");
    url.setQuery(query);

    QNetworkReply *reply = m_network.get(QNetworkRequest(url));
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        parseDirectionsReply(reply);
        reply->deleteLater();
    });
}

void NavigationService::parseDirectionsReply(QNetworkReply *reply) {
    m_isSearching = false;
    emit isSearchingChanged();

    if (reply->error() != QNetworkReply::NoError) {
        emit routeError(reply->errorString());
        return;
    }

    const QJsonDocument doc    = QJsonDocument::fromJson(reply->readAll());
    const QJsonArray    routes = doc.object().value("routes").toArray();
    if (routes.isEmpty()) {
        emit routeError("No route found");
        return;
    }

    const QJsonObject route = routes.first().toObject();

    // Build route path for MapPolyline — list of {latitude, longitude} maps
    m_routePath.clear();
    const QJsonArray coords = route.value("geometry").toObject()
                                   .value("coordinates").toArray();
    for (const QJsonValue &c : coords) {
        const QJsonArray pt = c.toArray();
        QVariantMap coord;
        coord["longitude"] = pt[0].toDouble();
        coord["latitude"]  = pt[1].toDouble();
        m_routePath.append(coord);
    }
    emit routePathChanged();

    // Build step list
    m_steps.clear();
    m_totalDurationS = 0;
    const QJsonArray legs = route.value("legs").toArray();
    for (const QJsonValue &legVal : legs) {
        const QJsonArray steps = legVal.toObject().value("steps").toArray();
        for (const QJsonValue &stepVal : steps) {
            const QJsonObject step = stepVal.toObject();
            Step s;
            s.instruction = step.value("maneuver").toObject().value("instruction").toString();
            s.distanceM   = step.value("distance").toDouble();
            s.durationS   = step.value("duration").toDouble();
            m_totalDurationS += s.durationS;
            m_steps.append(s);
        }
    }

    m_currentStep = 0;
    updateStepDisplay();
    emit routeReady();
}

void NavigationService::startNavigation() {
    if (m_steps.isEmpty()) return;
    m_isNavigating = true;
    m_currentStep  = 0;
    updateStepDisplay();
    emit isNavigatingChanged();
}

void NavigationService::stopNavigation() {
    m_isNavigating = false;
    m_steps.clear();
    m_routePath.clear();
    m_instruction  = "";
    m_distanceText = "";
    m_etaText      = "";
    m_destName     = "";
    emit isNavigatingChanged();
    emit routePathChanged();
    emit instructionChanged();
    emit distanceTextChanged();
    emit etaTextChanged();
    emit destNameChanged();
}

void NavigationService::advanceStep() {
    if (!m_isNavigating) return;
    if (m_currentStep >= m_steps.size() - 1) {
        stopNavigation();
        return;
    }
    m_currentStep++;
    updateStepDisplay();
}

void NavigationService::updateStepDisplay() {
    if (m_steps.isEmpty() || m_currentStep >= m_steps.size()) return;

    const Step &step = m_steps[m_currentStep];
    m_instruction = step.instruction;

    double remainingS = 0;
    for (int i = m_currentStep; i < m_steps.size(); ++i)
        remainingS += m_steps[i].durationS;

    m_distanceText = formatDistance(step.distanceM);
    m_etaText      = formatDuration(remainingS);

    emit instructionChanged();
    emit distanceTextChanged();
    emit etaTextChanged();
}

QString NavigationService::formatDistance(double meters) const {
    if (meters < 1000)
        return QString("%1 m").arg(static_cast<int>(meters / 10) * 10);
    return QString("%1 km").arg(meters / 1000.0, 0, 'f', 1);
}

QString NavigationService::formatDuration(double seconds) const {
    const int mins = qRound(seconds / 60.0);
    if (mins < 60) return QString("%1 min").arg(mins);
    return QString("%1 h %2 min").arg(mins / 60).arg(mins % 60);
}
