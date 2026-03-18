#pragma once
#include <QObject>
#include <QNetworkAccessManager>
#include <QVariantList>

class LocationService;

class NavigationService : public QObject {
    Q_OBJECT

    Q_PROPERTY(QString      accessToken  READ accessToken  CONSTANT)
    Q_PROPERTY(bool         isNavigating READ isNavigating NOTIFY isNavigatingChanged)
    Q_PROPERTY(bool         isSearching  READ isSearching  NOTIFY isSearchingChanged)
    Q_PROPERTY(QString      instruction  READ instruction  NOTIFY instructionChanged)
    Q_PROPERTY(QString      distanceText READ distanceText NOTIFY distanceTextChanged)
    Q_PROPERTY(QString      etaText      READ etaText      NOTIFY etaTextChanged)
    Q_PROPERTY(QString      destName     READ destName     NOTIFY destNameChanged)
    Q_PROPERTY(QVariantList routePath    READ routePath    NOTIFY routePathChanged)

public:
    explicit NavigationService(QObject *parent = nullptr);
    void setLocationService(LocationService *loc);

    QString      accessToken()  const { return m_accessToken; }
    bool         isNavigating() const { return m_isNavigating; }
    bool         isSearching()  const { return m_isSearching; }
    QString      instruction()  const { return m_instruction; }
    QString      distanceText() const { return m_distanceText; }
    QString      etaText()      const { return m_etaText; }
    QString      destName()     const { return m_destName; }
    QVariantList routePath()    const { return m_routePath; }

public slots:
    Q_INVOKABLE void searchAddress(const QString &address);
    Q_INVOKABLE void fetchRoute(double toLat, double toLng, const QString &destName);
    Q_INVOKABLE void startNavigation();
    Q_INVOKABLE void stopNavigation();
    Q_INVOKABLE void advanceStep();  // simulates GPS step advancement via DevPanel

signals:
    void isNavigatingChanged();
    void isSearchingChanged();
    void instructionChanged();
    void distanceTextChanged();
    void etaTextChanged();
    void destNameChanged();
    void routePathChanged();
    void routeReady();
    void routeError(const QString &message);

private:
    void loadToken();
    void parseGeocodeReply(QNetworkReply *reply, const QString &destName);
    void parseDirectionsReply(QNetworkReply *reply);
    void updateStepDisplay();
    QString formatDistance(double meters) const;
    QString formatDuration(double seconds) const;

    QNetworkAccessManager m_network;
    LocationService      *m_location = nullptr;

    QString      m_accessToken;
    bool         m_isNavigating = false;
    bool         m_isSearching  = false;
    QString      m_instruction;
    QString      m_distanceText;
    QString      m_etaText;
    QString      m_destName;
    QVariantList m_routePath;

    struct Step {
        QString instruction;
        double  distanceM = 0;
        double  durationS = 0;
    };
    QList<Step> m_steps;
    int         m_currentStep    = 0;
    double      m_totalDurationS = 0;
};
