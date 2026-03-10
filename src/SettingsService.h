//
// Created by chris on 3/7/26.
//
#pragma once
#include <QObject>
#include <QString>
#include <QSettings>

class SettingsService : public QObject
{
    Q_OBJECT

    // Theme behavior
    Q_PROPERTY(QString themeBehavior READ themeBehavior WRITE setThemeBehavior NOTIFY themeBehaviorChanged)

    // Display
    Q_PROPERTY(bool metricUnits READ metricUnits WRITE setMetricUnits NOTIFY metricUnitsChanged)

    // Vehicle behavior
    Q_PROPERTY(bool doorAutoLock READ doorAutoLock WRITE setDoorAutoLock NOTIFY doorAutoLockChanged)
    Q_PROPERTY(bool drlLights READ drlLights WRITE setDrlLights NOTIFY drlLightsChanged)

    // Maintenance
    Q_PROPERTY(int maintenanceIntervalMiles READ maintenanceIntervalMiles WRITE setMaintenanceIntervalMiles NOTIFY maintenanceIntervalMilesChanged)
    Q_PROPERTY(int maintenanceIntervalDays READ maintenanceIntervalDays WRITE setMaintenanceIntervalDays NOTIFY maintenanceIntervalDaysChanged)
    Q_PROPERTY(int lastMaintenanceMiles READ lastMaintenanceMiles WRITE setLastMaintenanceMiles NOTIFY lastMaintenanceMilesChanged)
    Q_PROPERTY(QString lastMaintenanceDate READ lastMaintenanceDate WRITE setLastMaintenanceDate NOTIFY lastMaintenanceDateChanged)

public:
    explicit SettingsService(QObject *parent = nullptr);

    QString themeBehavior() const { return m_themeBehavior; }
    bool metricUnits() const { return m_metricUnits; }
    bool doorAutoLock() const { return m_doorAutoLock; }
    bool drlLights() const { return m_drlLights; }
    int maintenanceIntervalMiles() const { return m_maintenanceIntervalMiles; }
    int maintenanceIntervalDays() const { return m_maintenanceIntervalDays; }
    int lastMaintenanceMiles() const { return m_lastMaintenanceMiles; }
    QString lastMaintenanceDate() const { return m_lastMaintenanceDate; }

public slots:
    void setThemeBehavior(const QString &v);
    void setMetricUnits(bool v);
    void setDoorAutoLock(bool v);
    void setDrlLights(bool v);
    void setMaintenanceIntervalMiles(int v);
    void setMaintenanceIntervalDays(int v);
    void setLastMaintenanceMiles(int v);
    void setLastMaintenanceDate(const QString &v);

signals:
    void themeBehaviorChanged();
    void metricUnitsChanged();
    void doorAutoLockChanged();
    void drlLightsChanged();
    void maintenanceIntervalMilesChanged();
    void maintenanceIntervalDaysChanged();
    void lastMaintenanceMilesChanged();
    void lastMaintenanceDateChanged();

private:
    void load();
    void save();

    QSettings m_settings;

    QString m_themeBehavior             = "auto";
    bool    m_metricUnits               = false;
    bool    m_doorAutoLock              = false;
    bool    m_drlLights                 = true;
    int     m_maintenanceIntervalMiles  = 5000;
    int     m_maintenanceIntervalDays   = 180;
    int     m_lastMaintenanceMiles      = 85000;
    QString m_lastMaintenanceDate       = "2025-01-15";
};