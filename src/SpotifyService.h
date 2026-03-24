#pragma once
#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QTcpServer>
#include <QTimer>

class SpotifyService : public QObject {
    Q_OBJECT

    Q_PROPERTY(QString trackName     READ trackName     NOTIFY trackNameChanged)
    Q_PROPERTY(QString artistName    READ artistName    NOTIFY artistNameChanged)
    Q_PROPERTY(QString albumName     READ albumName     NOTIFY albumNameChanged)
    Q_PROPERTY(QString albumArtUrl   READ albumArtUrl   NOTIFY albumArtUrlChanged)
    Q_PROPERTY(bool    isPlaying     READ isPlaying     NOTIFY isPlayingChanged)
    Q_PROPERTY(int     progressMs    READ progressMs    NOTIFY progressMsChanged)
    Q_PROPERTY(int     durationMs    READ durationMs    NOTIFY durationMsChanged)
    Q_PROPERTY(bool    authenticated READ authenticated NOTIFY authenticatedChanged)

public:
    explicit SpotifyService(QObject *parent = nullptr);

    QString trackName()     const { return m_trackName; }
    QString artistName()    const { return m_artistName; }
    QString albumName()     const { return m_albumName; }
    QString albumArtUrl()   const { return m_albumArtUrl; }
    bool    isPlaying()     const { return m_isPlaying; }
    int     progressMs()    const { return m_progressMs; }
    int     durationMs()    const { return m_durationMs; }
    bool    authenticated() const { return m_authenticated; }

public slots:
    void authenticate();
    void togglePlayPause();
    void next();
    void previous();

signals:
    void trackNameChanged();
    void artistNameChanged();
    void albumNameChanged();
    void albumArtUrlChanged();
    void isPlayingChanged();
    void progressMsChanged();
    void durationMsChanged();
    void authenticatedChanged();

private:
    void loadCredentials();
    void startAuthServer();
    void exchangeCode(const QString &code);
    void refreshAccessToken();
    void fetchCurrentlyPlaying();
    void handleCurrentlyPlayingResponse(QNetworkReply *reply);
    void applyTrackState(const QJsonObject &json);
    void sendPlayerCommand(const QString &endpoint, const QString &method);
    QNetworkRequest buildAuthRequest(const QString &url);

    QNetworkAccessManager m_network;
    QTcpServer            m_callbackServer;
    QTimer                m_pollTimer;
    QTimer                m_refreshTimer;

    QString m_clientId;
    QString m_clientSecret;
    QString m_accessToken;
    QString m_refreshToken;

    QString m_trackName;
    QString m_artistName;
    QString m_albumName;
    QString m_albumArtUrl;
    bool    m_isPlaying     = false;
    int     m_progressMs    = 0;
    int     m_durationMs    = 0;
    bool    m_authenticated = false;

    static const QString REDIRECT_URI;
    static const QString SCOPE;
};
