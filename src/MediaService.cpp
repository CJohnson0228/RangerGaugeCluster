#include "MediaService.h"

MediaService::MediaService(QObject *parent) : QObject(parent) {}

void MediaService::setSourceImage(const QString &v) { if (m_sourceImage != v) { m_sourceImage = v; emit sourceImageChanged(); } }
void MediaService::setAlbumArtUrl(const QString &v) { if (m_albumArtUrl != v) { m_albumArtUrl = v; emit albumArtUrlChanged(); } }
void MediaService::setArtistName(const QString &v)  { if (m_artistName  != v) { m_artistName  = v; emit artistNameChanged(); } }
void MediaService::setTrackName(const QString &v)   { if (m_trackName   != v) { m_trackName   = v; emit trackNameChanged(); } }
void MediaService::setAlbumName(const QString &v)   { if (m_albumName   != v) { m_albumName   = v; emit albumNameChanged(); } }
void MediaService::setSourceName(const QString &v)  { if (m_sourceName  != v) { m_sourceName  = v; emit sourceNameChanged(); } }
void MediaService::setIsPlaying(bool v)             { if (m_isPlaying   != v) { m_isPlaying   = v; emit isPlayingChanged(); } }
void MediaService::setProgressMs(int v)             { if (m_progressMs  != v) { m_progressMs  = v; emit progressMsChanged(); } }
void MediaService::setDurationMs(int v)             { if (m_durationMs  != v) { m_durationMs  = v; emit durationMsChanged(); } }
