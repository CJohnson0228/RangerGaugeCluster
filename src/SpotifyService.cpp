#include "SpotifyService.h"
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QUrlQuery>
#include <QDesktopServices>
#include <QTcpSocket>
#include <QSettings>
#include <QDir>
#include <QDateTime>
#include <QFile>
#include <QTextStream>
#include <QCoreApplication>

const QString SpotifyService::REDIRECT_URI = "http://127.0.0.1:8888/callback";
const QString SpotifyService::SCOPE =
    "user-read-currently-playing user-read-playback-state user-modify-playback-state";

SpotifyService::SpotifyService(QObject *parent) : QObject(parent) {
    loadCredentials();

    m_pollTimer.setInterval(2000);
    connect(&m_pollTimer, &QTimer::timeout, this, &SpotifyService::fetchCurrentlyPlaying);

    // Restore saved session
    QSettings tokens("HMItest", "spotify");
    m_accessToken  = tokens.value("access_token").toString();
    m_refreshToken = tokens.value("refresh_token").toString();
    qint64 expiresAt = tokens.value("expires_at", 0).toLongLong();

    if (!m_refreshToken.isEmpty()) {
        if (QDateTime::currentSecsSinceEpoch() >= expiresAt) {
            refreshAccessToken();
        } else {
            m_authenticated = true;
            emit authenticatedChanged();
            m_pollTimer.start();
            fetchCurrentlyPlaying();

            qint64 remaining = expiresAt - QDateTime::currentSecsSinceEpoch();
            m_refreshTimer.setSingleShot(true);
            m_refreshTimer.setInterval(remaining * 1000);
            connect(&m_refreshTimer, &QTimer::timeout, this, &SpotifyService::refreshAccessToken);
            m_refreshTimer.start();
        }
    }
}

void SpotifyService::loadCredentials() {
    // Look for .env next to the executable, then one directory up (project root during dev)
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
            const QString key = line.left(eq).trimmed();
            const QString val = line.mid(eq + 1).trimmed();
            if (key == "SPOTIFY_CLIENT_ID")     m_clientId     = val;
            else if (key == "SPOTIFY_CLIENT_SECRET") m_clientSecret = val;
        }
        break;
    }
}

void SpotifyService::authenticate() {
    startAuthServer();

    QUrl url("https://accounts.spotify.com/authorize");
    QUrlQuery q;
    q.addQueryItem("client_id",     m_clientId);
    q.addQueryItem("response_type", "code");
    q.addQueryItem("redirect_uri",  REDIRECT_URI);
    q.addQueryItem("scope",         SCOPE);
    url.setQuery(q);

    QDesktopServices::openUrl(url);
}

void SpotifyService::startAuthServer() {
    if (m_callbackServer.isListening()) return;
    m_callbackServer.listen(QHostAddress::LocalHost, 8888);

    connect(&m_callbackServer, &QTcpServer::newConnection, this, [this]() {
        QTcpSocket *socket = m_callbackServer.nextPendingConnection();
        connect(socket, &QTcpSocket::readyRead, this, [this, socket]() {
            const QString request = QString::fromUtf8(socket->readAll());
            // Parse: GET /callback?code=XXXX[&...] HTTP/1.1
            const int codeStart = request.indexOf("code=");
            if (codeStart != -1) {
                int codeEnd = request.indexOf('&', codeStart);
                if (codeEnd == -1) codeEnd = request.indexOf(' ', codeStart);
                const QString code = request.mid(codeStart + 5, codeEnd - codeStart - 5);

                socket->write(
                    "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n"
                    "<html><body style='font-family:sans-serif;text-align:center;padding:60px;"
                    "background:#191414;color:#1DB954'>"
                    "<h2>&#10003; Connected to Spotify</h2>"
                    "<p style='color:#fff'>Return to the vehicle HMI.</p>"
                    "</body></html>"
                );
                socket->flush();
                socket->disconnectFromHost();
                m_callbackServer.close();
                exchangeCode(code);
            }
        });
    });
}

void SpotifyService::exchangeCode(const QString &code) {
    QNetworkRequest req(QUrl("https://accounts.spotify.com/api/token"));
    req.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    req.setRawHeader("Authorization",
        "Basic " + (m_clientId + ":" + m_clientSecret).toUtf8().toBase64());

    QUrlQuery body;
    body.addQueryItem("grant_type",   "authorization_code");
    body.addQueryItem("code",         code);
    body.addQueryItem("redirect_uri", REDIRECT_URI);

    auto *reply = m_network.post(req, body.toString(QUrl::FullyEncoded).toUtf8());
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        reply->deleteLater();
        if (reply->error() != QNetworkReply::NoError) return;

        const auto json  = QJsonDocument::fromJson(reply->readAll()).object();
        m_accessToken    = json["access_token"].toString();
        m_refreshToken   = json["refresh_token"].toString();
        int expiresIn    = json["expires_in"].toInt(3600);
        qint64 expiresAt = QDateTime::currentSecsSinceEpoch() + expiresIn - 60;

        QSettings tokens("HMItest", "spotify");
        tokens.setValue("access_token",  m_accessToken);
        tokens.setValue("refresh_token", m_refreshToken);
        tokens.setValue("expires_at",    expiresAt);

        m_refreshTimer.setSingleShot(true);
        m_refreshTimer.setInterval((expiresIn - 60) * 1000);
        connect(&m_refreshTimer, &QTimer::timeout, this, &SpotifyService::refreshAccessToken);
        m_refreshTimer.start();

        m_authenticated = true;
        emit authenticatedChanged();
        m_pollTimer.start();
        fetchCurrentlyPlaying();
    });
}

void SpotifyService::refreshAccessToken() {
    QNetworkRequest req(QUrl("https://accounts.spotify.com/api/token"));
    req.setHeader(QNetworkRequest::ContentTypeHeader, "application/x-www-form-urlencoded");
    req.setRawHeader("Authorization",
        "Basic " + (m_clientId + ":" + m_clientSecret).toUtf8().toBase64());

    QUrlQuery body;
    body.addQueryItem("grant_type",    "refresh_token");
    body.addQueryItem("refresh_token", m_refreshToken);

    auto *reply = m_network.post(req, body.toString(QUrl::FullyEncoded).toUtf8());
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        reply->deleteLater();
        if (reply->error() != QNetworkReply::NoError) return;

        const auto json  = QJsonDocument::fromJson(reply->readAll()).object();
        m_accessToken    = json["access_token"].toString();
        int expiresIn    = json["expires_in"].toInt(3600);
        qint64 expiresAt = QDateTime::currentSecsSinceEpoch() + expiresIn - 60;

        if (json.contains("refresh_token"))
            m_refreshToken = json["refresh_token"].toString();

        QSettings tokens("HMItest", "spotify");
        tokens.setValue("access_token",  m_accessToken);
        tokens.setValue("refresh_token", m_refreshToken);
        tokens.setValue("expires_at",    expiresAt);

        m_refreshTimer.setInterval((expiresIn - 60) * 1000);
        m_refreshTimer.start();

        if (!m_authenticated) {
            m_authenticated = true;
            emit authenticatedChanged();
            m_pollTimer.start();
        }
        fetchCurrentlyPlaying();
    });
}

QNetworkRequest SpotifyService::buildAuthRequest(const QString &url) {
    QNetworkRequest req{QUrl(url)};
    req.setRawHeader("Authorization", ("Bearer " + m_accessToken).toUtf8());
    return req;
}

void SpotifyService::fetchCurrentlyPlaying() {
    auto *reply = m_network.get(
        buildAuthRequest("https://api.spotify.com/v1/me/player/currently-playing"));
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        reply->deleteLater();
        handleCurrentlyPlayingResponse(reply);
    });
}

void SpotifyService::handleCurrentlyPlayingResponse(QNetworkReply *reply) {
    const int status = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
    if (status == 401) { refreshAccessToken(); return; }
    if (status == 204 || reply->error() != QNetworkReply::NoError) {
        if (m_isPlaying) { m_isPlaying = false; emit isPlayingChanged(); }
        return;
    }
    applyTrackState(QJsonDocument::fromJson(reply->readAll()).object());
}

void SpotifyService::applyTrackState(const QJsonObject &json) {
    const auto item    = json["item"].toObject();
    const auto album   = item["album"].toObject();
    const auto artists = item["artists"].toArray();

    const bool    playing   = json["is_playing"].toBool();
    const int     progress  = json["progress_ms"].toInt();
    const int     duration  = item["duration_ms"].toInt();
    const QString track     = item["name"].toString();
    const QString artist    = artists.isEmpty() ? QString()
                            : artists[0].toObject()["name"].toString();
    const QString albumName = album["name"].toString();
    const QString artUrl    = album["images"].toArray().isEmpty() ? QString()
                            : album["images"].toArray()[0].toObject()["url"].toString();

    if (m_trackName   != track)     { m_trackName    = track;     emit trackNameChanged(); }
    if (m_artistName  != artist)    { m_artistName   = artist;    emit artistNameChanged(); }
    if (m_albumName   != albumName) { m_albumName    = albumName; emit albumNameChanged(); }
    if (m_albumArtUrl != artUrl)    { m_albumArtUrl  = artUrl;    emit albumArtUrlChanged(); }
    if (m_isPlaying   != playing)   { m_isPlaying    = playing;   emit isPlayingChanged(); }
    if (m_progressMs  != progress)  { m_progressMs   = progress;  emit progressMsChanged(); }
    if (m_durationMs  != duration)  { m_durationMs   = duration;  emit durationMsChanged(); }
}

void SpotifyService::togglePlayPause() {
    sendPlayerCommand(m_isPlaying ? "/v1/me/player/pause" : "/v1/me/player/play", "PUT");
}

void SpotifyService::next() {
    sendPlayerCommand("/v1/me/player/next", "POST");
}

void SpotifyService::previous() {
    sendPlayerCommand("/v1/me/player/previous", "POST");
}

void SpotifyService::sendPlayerCommand(const QString &endpoint, const QString &method) {
    QNetworkRequest req = buildAuthRequest("https://api.spotify.com" + endpoint);
    req.setHeader(QNetworkRequest::ContentLengthHeader, 0);

    QNetworkReply *reply = (method == "POST")
        ? m_network.post(req, QByteArray())
        : m_network.put(req, QByteArray());

    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        reply->deleteLater();
        QTimer::singleShot(300, this, &SpotifyService::fetchCurrentlyPlaying);
    });
}
