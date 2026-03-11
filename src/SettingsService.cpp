//
// Created by chris on 3/7/26.
//

#include "SettingsService.h"

SettingsService::SettingsService(QObject *parent)
    : QObject(parent)
    , m_settings("RangerHMI", "Settings")
{
    load();
}

void SettingsService::load()
{
    m_themeBehavior             = m_settings.value("themeBehavior", "auto").toString();
    m_metricUnits               = m_settings.value("metricUnits", false).toBool();
    m_use24HourTime             = m_settings.value("use24HourTime", false).toBool();
    m_doorAutoLock              = m_settings.value("doorAutoLock", false).toBool();
    m_drlLights                 = m_settings.value("drlLights", true).toBool();
    m_maintenanceIntervalMiles  = m_settings.value("maintenanceIntervalMiles", 5000).toInt();
    m_maintenanceIntervalDays   = m_settings.value("maintenanceIntervalDays", 180).toInt();
    m_lastMaintenanceMiles      = m_settings.value("lastMaintenanceMiles", 85000).toInt();
    m_lastMaintenanceDate       = m_settings.value("lastMaintenanceDate", "2025-01-15").toString();
}

void SettingsService::save()
{
    m_settings.setValue("themeBehavior", m_themeBehavior);
    m_settings.setValue("metricUnits", m_metricUnits);
    m_settings.setValue("use24HourTime", m_use24HourTime);
    m_settings.setValue("doorAutoLock", m_doorAutoLock);
    m_settings.setValue("drlLights", m_drlLights);
    m_settings.setValue("maintenanceIntervalMiles", m_maintenanceIntervalMiles);
    m_settings.setValue("maintenanceIntervalDays", m_maintenanceIntervalDays);
    m_settings.setValue("lastMaintenanceMiles", m_lastMaintenanceMiles);
    m_settings.setValue("lastMaintenanceDate", m_lastMaintenanceDate);
    m_settings.sync();
}

void SettingsService::setThemeBehavior(const QString &v) { if (m_themeBehavior != v) { m_themeBehavior = v; emit themeBehaviorChanged(); save(); } }
void SettingsService::setMetricUnits(bool v) { if (m_metricUnits != v) { m_metricUnits = v; emit metricUnitsChanged(); save(); } }
void SettingsService::setUse24HourTime(bool v) { if (m_use24HourTime != v) { m_use24HourTime = v; emit use24HourTimeChanged(); save(); } }
void SettingsService::setDoorAutoLock(bool v) { if (m_doorAutoLock != v) { m_doorAutoLock = v; emit doorAutoLockChanged(); save(); } }
void SettingsService::setDrlLights(bool v) { if (m_drlLights != v) { m_drlLights = v; emit drlLightsChanged(); save(); } }
void SettingsService::setMaintenanceIntervalMiles(int v) { if (m_maintenanceIntervalMiles != v) { m_maintenanceIntervalMiles = v; emit maintenanceIntervalMilesChanged(); save(); } }
void SettingsService::setMaintenanceIntervalDays(int v) { if (m_maintenanceIntervalDays != v) { m_maintenanceIntervalDays = v; emit maintenanceIntervalDaysChanged(); save(); } }
void SettingsService::setLastMaintenanceMiles(int v) { if (m_lastMaintenanceMiles != v) { m_lastMaintenanceMiles = v; emit lastMaintenanceMilesChanged(); save(); } }
void SettingsService::setLastMaintenanceDate(const QString &v) { if (m_lastMaintenanceDate != v) { m_lastMaintenanceDate = v; emit lastMaintenanceDateChanged(); save(); } }