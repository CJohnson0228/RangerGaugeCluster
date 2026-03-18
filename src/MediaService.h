#pragma once
#include <QObject>
#include <QString>

class MediaService : public QObject {
    Q_OBJECT

    Q_PROPERTY(QString sourceImage  READ sourceImage  WRITE setSourceImage  NOTIFY sourceImageChanged)
    Q_PROPERTY(QString albumArtUrl  READ albumArtUrl  WRITE setAlbumArtUrl  NOTIFY albumArtUrlChanged)
    Q_PROPERTY(QString artistName   READ artistName   WRITE setArtistName   NOTIFY artistNameChanged)
    Q_PROPERTY(QString trackName    READ trackName    WRITE setTrackName    NOTIFY trackNameChanged)
    Q_PROPERTY(QString albumName    READ albumName    WRITE setAlbumName    NOTIFY albumNameChanged)
    Q_PROPERTY(QString sourceName   READ sourceName   WRITE setSourceName   NOTIFY sourceNameChanged)
    Q_PROPERTY(bool    isPlaying    READ isPlaying    WRITE setIsPlaying    NOTIFY isPlayingChanged)
    Q_PROPERTY(int     progressMs   READ progressMs   WRITE setProgressMs   NOTIFY progressMsChanged)
    Q_PROPERTY(int     durationMs   READ durationMs   WRITE setDurationMs   NOTIFY durationMsChanged)

public:
    explicit MediaService(QObject *parent = nullptr);

    QString sourceImage() const { return m_sourceImage; }
    QString albumArtUrl() const { return m_albumArtUrl; }
    QString artistName()  const { return m_artistName; }
    QString trackName()   const { return m_trackName; }
    QString albumName()   const { return m_albumName; }
    QString sourceName()  const { return m_sourceName; }
    bool    isPlaying()   const { return m_isPlaying; }
    int     progressMs()  const { return m_progressMs; }
    int     durationMs()  const { return m_durationMs; }

public slots:
    void setSourceImage(const QString &v);
    void setAlbumArtUrl(const QString &v);
    void setArtistName(const QString &v);
    void setTrackName(const QString &v);
    void setAlbumName(const QString &v);
    void setSourceName(const QString &v);
    void setIsPlaying(bool v);
    void setProgressMs(int v);
    void setDurationMs(int v);

signals:
    void sourceImageChanged();
    void albumArtUrlChanged();
    void artistNameChanged();
    void trackNameChanged();
    void albumNameChanged();
    void sourceNameChanged();
    void isPlayingChanged();
    void progressMsChanged();
    void durationMsChanged();

private:
    QString m_sourceImage;
    QString m_albumArtUrl;
    QString m_artistName;
    QString m_trackName;
    QString m_albumName;
    QString m_sourceName;
    bool    m_isPlaying  = false;
    int     m_progressMs = 0;
    int     m_durationMs = 0;
};
