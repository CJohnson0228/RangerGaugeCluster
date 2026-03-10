//
// Created by chris on 3/7/26.
//
#pragma once
#include <QObject>
#include <QProperty>
#include <QString>

class MediaService: public QObject
{
    Q_OBJECT

    Q_PROPERTY(QString sourceImage READ sourceImage WRITE setSourceImage NOTIFY sourceImageChanged)
    Q_PROPERTY(QString artistName READ artistName WRITE setArtistName NOTIFY artistNameChanged)
    Q_PROPERTY(QString trackName READ trackName WRITE setTrackName NOTIFY trackNameChanged)
    Q_PROPERTY(QString sourceName READ sourceName WRITE setSourceName NOTIFY sourceNameChanged)
    Q_PROPERTY(bool isPlaying READ isPlaying WRITE setIsPlaying NOTIFY isPlayingChanged)

public:
    explicit MediaService(QObject *parent = nullptr);

    QString sourceImage() const { return m_sourceImage; }
    QString artistName() const { return m_artistName; }
    QString trackName() const { return m_trackName; }
    QString sourceName() const { return m_sourceName; }
    bool isPlaying() const { return m_isPlaying; }

public slots:
    void setSourceImage(const QString &v);
    void setArtistName(const QString &v);
    void setTrackName(const QString &v);
    void setSourceName(const QString &v);
    void setIsPlaying(bool v);

    signals:
        void sourceImageChanged();
    void artistNameChanged();
    void trackNameChanged();
    void sourceNameChanged();
    void isPlayingChanged();

private:
    QString m_sourceImage = "tool.jpg";
    QString m_artistName  = "Tool";
    QString m_trackName   = "Sober";
    QString m_sourceName  = "Spotify";
    bool    m_isPlaying   = true;
};
