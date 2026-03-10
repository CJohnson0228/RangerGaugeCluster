//
// Created by chris on 3/7/26.
//
#include "MediaService.h"

MediaService::MediaService(QObject *parent) : QObject(parent) {}

void MediaService::setSourceImage(const QString &v) { if (m_sourceImage != v) { m_sourceImage = v; emit sourceImageChanged(); } }
void MediaService::setArtistName(const QString &v) { if (m_artistName != v) { m_artistName = v; emit artistNameChanged(); } }
void MediaService::setTrackName(const QString &v) { if (m_trackName != v) { m_trackName = v; emit trackNameChanged(); } }
void MediaService::setSourceName(const QString &v) { if (m_sourceName != v) { m_sourceName = v; emit sourceNameChanged(); } }
void MediaService::setIsPlaying(bool v) { if (m_isPlaying != v) { m_isPlaying = v; emit isPlayingChanged(); } }