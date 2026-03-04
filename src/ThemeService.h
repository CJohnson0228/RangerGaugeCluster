//
// Created by chris on 3/3/26.
//
#pragma once
#include <QObject>
#include <QString>
#include <QColor>
#include <QQuickItem>

class ThemeService : public QObject
{
    Q_OBJECT

    // Mode
    Q_PROPERTY(bool darkMode READ darkMode WRITE setDarkMode NOTIFY darkModeChanged)

    // Active colors
    Q_PROPERTY(QColor background READ background NOTIFY themeChanged)
    Q_PROPERTY(QColor foreground READ foreground NOTIFY themeChanged)
    Q_PROPERTY(QColor card READ card NOTIFY themeChanged)
    Q_PROPERTY(QColor paper READ paper NOTIFY themeChanged)
    Q_PROPERTY(QColor muted READ muted NOTIFY themeChanged)
    Q_PROPERTY(QColor textMuted READ textMuted NOTIFY themeChanged)
    Q_PROPERTY(QColor border READ border NOTIFY themeChanged)
    Q_PROPERTY(QColor input READ input NOTIFY themeChanged)
    Q_PROPERTY(QColor ring READ ring NOTIFY themeChanged)
    Q_PROPERTY(QColor primary READ primary NOTIFY themeChanged)
    Q_PROPERTY(QColor accent READ accent NOTIFY themeChanged)
    Q_PROPERTY(QColor error READ error NOTIFY themeChanged)
    Q_PROPERTY(QColor success READ success NOTIFY themeChanged)
    Q_PROPERTY(QColor info READ info NOTIFY themeChanged)
    Q_PROPERTY(QColor gradientOuter READ gradientOuter NOTIFY themeChanged)
    Q_PROPERTY(QColor gradientInner READ gradientInner NOTIFY themeChanged)

    // Static dark palette (for components that need direct access)
    Q_PROPERTY(QColor darkBackground READ darkBackground CONSTANT)
    Q_PROPERTY(QColor darkForeground READ darkForeground CONSTANT)
    Q_PROPERTY(QColor darkGradientInner READ darkGradientInner CONSTANT)
    Q_PROPERTY(QColor darkGradientOuter READ darkGradientOuter CONSTANT)
    Q_PROPERTY(QColor darkBorder READ darkBorder CONSTANT)
    Q_PROPERTY(QColor darkTextMuted READ darkTextMuted CONSTANT)
    Q_PROPERTY(QColor darkAccent READ darkAccent CONSTANT)
    Q_PROPERTY(QColor darkPrimary READ darkPrimary CONSTANT)

    // Timing
    Q_PROPERTY(int toggleTimer READ toggleTimer CONSTANT)

    // Resource paths
    Q_PROPERTY(QString resourcePath READ resourcePath CONSTANT)
    Q_PROPERTY(QString iconPath READ iconPath CONSTANT)
    Q_PROPERTY(QString fontPath READ fontPath CONSTANT)
    Q_PROPERTY(QString imagePath READ imagePath CONSTANT)

    // Fonts
    Q_PROPERTY(QString fontQuicksand READ fontQuicksand CONSTANT)
    Q_PROPERTY(QString fontOxanium READ fontOxanium CONSTANT)
    Q_PROPERTY(QString fontBigShoulders READ fontBigShoulders CONSTANT)

    // Background item for glassmorphic blur
    Q_PROPERTY(QQuickItem* backgroundItem READ backgroundItem
               WRITE setBackgroundItem NOTIFY backgroundItemChanged)

public:
    explicit ThemeService(QObject *parent = nullptr);

    // Mode
    bool darkMode() const { return m_darkMode; }

    // Active color getters
    QColor background() const { return m_background; }
    QColor foreground() const { return m_foreground; }
    QColor card() const { return m_card; }
    QColor paper() const { return m_paper; }
    QColor muted() const { return m_muted; }
    QColor textMuted() const { return m_textMuted; }
    QColor border() const { return m_border; }
    QColor input() const { return m_input; }
    QColor ring() const { return m_ring; }
    QColor primary() const { return m_primary; }
    QColor accent() const { return m_accent; }
    QColor error() const { return m_error; }
    QColor success() const { return m_success; }
    QColor info() const { return m_info; }
    QColor gradientOuter() const { return m_gradientOuter; }
    QColor gradientInner() const { return m_gradientInner; }

    // Static dark palette getters
    QColor darkBackground() const { return QColor("#000000"); }
    QColor darkForeground() const { return QColor("#fdfdfd"); }
    QColor darkGradientInner() const { return QColor("#0b0a0a"); }
    QColor darkGradientOuter() const { return QColor("#191818"); }
    QColor darkBorder() const { return QColor("#333333"); }
    QColor darkTextMuted() const { return QColor("#ababab"); }
    QColor darkAccent() const { return QColor("#ffd911"); }
    QColor darkPrimary() const { return QColor("#ff9d11"); }

    // Timing
    int toggleTimer() const { return 500; }

    // Resource paths
    QString resourcePath() const { return "qrc:/qt/qml/HMItestUI/resources/"; }
    QString iconPath() const { return resourcePath() + "icons/"; }
    QString fontPath() const { return resourcePath() + "fonts/"; }
    QString imagePath() const { return resourcePath() + "images/"; }

    // Fonts
    QString fontQuicksand() const { return m_fontQuicksand; }
    QString fontOxanium() const { return m_fontOxanium; }
    QString fontBigShoulders() const { return m_fontBigShoulders; }

    // Background item
    QQuickItem* backgroundItem() const { return m_backgroundItem; }

public slots:
    void setDarkMode(bool v);
    void setBackgroundItem(QQuickItem* item);
    void setFontQuicksand(const QString& v) { m_fontQuicksand = v; }
    void setFontOxanium(const QString& v) { m_fontOxanium = v; }
    void setFontBigShoulders(const QString& v) { m_fontBigShoulders = v; }

signals:
    void darkModeChanged();
    void themeChanged();
    void backgroundItemChanged();

private:
    void applyTheme();

    bool m_darkMode = true;

    // Active colors
    QColor m_background;
    QColor m_foreground;
    QColor m_card;
    QColor m_paper;
    QColor m_muted;
    QColor m_textMuted;
    QColor m_border;
    QColor m_input;
    QColor m_ring;
    QColor m_primary;
    QColor m_accent;
    QColor m_error;
    QColor m_success;
    QColor m_info;
    QColor m_gradientOuter;
    QColor m_gradientInner;

    // Fonts
    QString m_fontQuicksand;
    QString m_fontOxanium;
    QString m_fontBigShoulders;

    // Background item
    QQuickItem* m_backgroundItem = nullptr;

    // Dark palette
    const QColor dk_background  = QColor("#000000");
    const QColor dk_foreground  = QColor("#fdfdfd");
    const QColor dk_card        = QColor("#151314");
    const QColor dk_paper       = QColor("#1c1c1c");
    const QColor dk_muted       = QColor("#343434");
    const QColor dk_textMuted   = QColor("#ababab");
    const QColor dk_border      = QColor("#333333");
    const QColor dk_input       = QColor("#111111");
    const QColor dk_ring        = QColor("#555555");
    const QColor dk_primary     = QColor("#ff9d11");
    const QColor dk_accent      = QColor("#ffd911");
    const QColor dk_error       = QColor("#ff2612");
    const QColor dk_success     = QColor("#27E853");
    const QColor dk_info        = QColor("#4782e4");
    const QColor dk_gradOuter   = QColor("#191818");
    const QColor dk_gradInner   = QColor("#0b0a0a");

    // Light palette
    const QColor lt_background  = QColor("#ffffff");
    const QColor lt_foreground  = QColor("#030303");
    const QColor lt_card        = QColor("#eaeceb");
    const QColor lt_paper       = QColor("#e3e3e3");
    const QColor lt_muted       = QColor("#9a9a9a");
    const QColor lt_textMuted   = QColor("#454545");
    const QColor lt_border      = QColor("#cccccc");
    const QColor lt_input       = QColor("#eeeeee");
    const QColor lt_ring        = QColor("#aaaaaa");
    const QColor lt_primary     = QColor("#ffbf66");
    const QColor lt_accent      = QColor("#ffe975");
    const QColor lt_error       = QColor("#f54d3d");
    const QColor lt_success     = QColor("#27E853");
    const QColor lt_info        = QColor("#7AA5EB");
    const QColor lt_gradOuter   = QColor("#e6e7e7");
    const QColor lt_gradInner   = QColor("#f4f5f5");
};