#pragma once
#include <QObject>
#include <QNetworkAccessManager>
#include <QVariantList>

class LocationService;
class QNetworkReply;

class NavigationService : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString      accessToken  READ accessToken  CONSTANT)
    Q_PROPERTY(int          navPitch     READ navPitch     WRITE setNavPitch  NOTIFY navPitchChanged)
    Q_PROPERTY(int          navZoom      READ navZoom      WRITE setNavZoom   NOTIFY navZoomChanged)
    Q_PROPERTY(bool         isSearching  READ isSearching  NOTIFY isSearchingChanged)
    Q_PROPERTY(bool         isNavigating READ isNavigating NOTIFY isNavigatingChanged)
    Q_PROPERTY(QString      destName     READ destName     NOTIFY destNameChanged)
    Q_PROPERTY(QString      etaText      READ etaText      NOTIFY etaTextChanged)
    Q_PROPERTY(QString      totalDistText READ totalDistText NOTIFY totalDistTextChanged)
    Q_PROPERTY(QString      instruction  READ instruction  NOTIFY instructionChanged)
    Q_PROPERTY(QString      distanceText READ distanceText NOTIFY distanceTextChanged)
    Q_PROPERTY(QVariantList routePath    READ routePath    NOTIFY routePathChanged)
    Q_PROPERTY(QVariantList steps        READ steps        NOTIFY stepsChanged)
    Q_PROPERTY(int          currentStep  READ currentStep  NOTIFY currentStepChanged)

public:
    explicit NavigationService(QObject *parent = nullptr);
    void setLocationService(LocationService *loc);

    QString      accessToken()   const { return m_accessToken; }
    int          navPitch()      const { return m_navPitch; }
    int          navZoom()       const { return m_navZoom; }
    bool         isSearching()   const { return m_isSearching; }
    bool         isNavigating()  const { return m_isNavigating; }
    QString      destName()      const { return m_destName; }
    QString      etaText()       const { return m_etaText; }
    QString      totalDistText() const { return m_totalDistText; }
    QString      instruction()   const { return m_instruction; }
    QString      distanceText()  const { return m_distanceText; }
    QVariantList routePath()     const { return m_routePath; }
    QVariantList steps()         const { return m_steps; }
    int          currentStep()   const { return m_currentStep; }

public slots:
    void setNavPitch(int v) { if (m_navPitch != v) { m_navPitch = v; emit navPitchChanged(); } }
    void setNavZoom(int v)  { if (m_navZoom  != v) { m_navZoom  = v; emit navZoomChanged();  } }

    Q_INVOKABLE void searchAddress(const QString &address);
    Q_INVOKABLE void fetchRoute(double toLat, double toLng, const QString &destName);
    Q_INVOKABLE void startNavigation();
    Q_INVOKABLE void stopNavigation();

signals:
    void navPitchChanged();
    void navZoomChanged();
    void isSearchingChanged();
    void isNavigatingChanged();
    void destNameChanged();
    void etaTextChanged();
    void totalDistTextChanged();
    void instructionChanged();
    void distanceTextChanged();
    void routePathChanged();
    void stepsChanged();
    void currentStepChanged();
    void routeReady();
    void routeError(const QString &msg);

private:
    void loadToken();
    void parseGeocodeReply(QNetworkReply *reply, const QString &destName);
    void parseDirectionsReply(QNetworkReply *reply);
    void checkPosition();
    void updateStepDisplay();
    QString formatDistance(double meters) const;
    QString formatDuration(double seconds) const;

    QNetworkAccessManager m_network;
    LocationService      *m_location = nullptr;

    QString m_accessToken;
    int     m_navPitch    = 60;
    int     m_navZoom     = 17;

    bool         m_isSearching  = false;
    bool         m_isNavigating = false;
    QString      m_destName;
    QString      m_etaText;
    QString      m_totalDistText;
    QString      m_instruction;
    QString      m_distanceText;
    QVariantList m_routePath;   // [{lat, lng}, ...] for the map line
    QVariantList m_steps;       // [{instruction, distanceText, type, modifier, endLat, endLng}, ...]
    int          m_currentStep  = 0;

    double m_totalDurationS = 0;
};
