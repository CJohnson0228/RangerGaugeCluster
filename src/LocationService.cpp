//
// Created by chris on 3/7/26.
//

#include "LocationService.h"

LocationService::LocationService(QObject *parent) : QObject(parent) {}

void LocationService::setLocalSpeedLimit(qreal v) { if (m_localSpeedLimit != v) { m_localSpeedLimit = v; emit localSpeedLimitChanged(); } }
void LocationService::setLatitude(qreal v) { if (m_latitude != v) { m_latitude = v; emit latitudeChanged(); } }
void LocationService::setLongitude(qreal v) { if (m_longitude != v) { m_longitude = v; emit longitudeChanged(); } }
void LocationService::setSunriseTime(const QString &v) { if (m_sunriseTime != v) { m_sunriseTime = v; emit sunriseTimeChanged(); } }
void LocationService::setSunsetTime(const QString &v) { if (m_sunsetTime != v) { m_sunsetTime = v; emit sunsetTimeChanged(); } }
void LocationService::setOutsideTemp(qreal v) { if (m_outsideTemp != v) { m_outsideTemp = v; emit outsideTempChanged(); } }
void LocationService::setHeading(qreal v) { if (m_heading != v) { m_heading = v; emit headingChanged(); } }