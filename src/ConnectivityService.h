#pragma once
#include <QObject>

class ConnectivityService : public QObject
{
    Q_OBJECT

    Q_PROPERTY(bool btConnected READ btConnected WRITE setBtConnected NOTIFY btConnectedChanged)
    Q_PROPERTY(int cellSignalBars READ cellSignalBars WRITE setCellSignalBars NOTIFY cellSignalBarsChanged)

public:
    explicit ConnectivityService(QObject *parent = nullptr) : QObject(parent) {}

    bool btConnected() const { return m_btConnected; }
    int cellSignalBars() const { return m_cellSignalBars; }

public slots:
    void setBtConnected(bool v) { if (m_btConnected != v) { m_btConnected = v; emit btConnectedChanged(); } }
    void setCellSignalBars(int v) { if (m_cellSignalBars != v) { m_cellSignalBars = v; emit cellSignalBarsChanged(); } }

signals:
    void btConnectedChanged();
    void cellSignalBarsChanged();

private:
    bool m_btConnected    = false;
    int  m_cellSignalBars = 0;     // 0 = no signal, 5 = full
};
