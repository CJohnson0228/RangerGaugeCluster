//
// Created by chris on 3/3/26.
//

#include "ThemeService.h"

ThemeService::ThemeService(QObject *parent) : QObject(parent)
{
    applyTheme();
}

void ThemeService::setDarkMode(bool v)
{
    if (m_darkMode != v) {
        m_darkMode = v;
        applyTheme();
        emit darkModeChanged();
    }
}

void ThemeService::setBackgroundItem(QQuickItem* item)
{
    if (m_backgroundItem != item) {
        m_backgroundItem = item;
        emit backgroundItemChanged();
    }
}

void ThemeService::applyTheme()
{
    m_background    = m_darkMode ? dk_background  : lt_background;
    m_foreground    = m_darkMode ? dk_foreground  : lt_foreground;
    m_card          = m_darkMode ? dk_card        : lt_card;
    m_paper         = m_darkMode ? dk_paper       : lt_paper;
    m_muted         = m_darkMode ? dk_muted       : lt_muted;
    m_textMuted     = m_darkMode ? dk_textMuted   : lt_textMuted;
    m_border        = m_darkMode ? dk_border      : lt_border;
    m_input         = m_darkMode ? dk_input       : lt_input;
    m_ring          = m_darkMode ? dk_ring        : lt_ring;
    m_primary       = m_darkMode ? dk_primary     : lt_primary;
    m_accent        = m_darkMode ? dk_accent      : lt_accent;
    m_error         = m_darkMode ? dk_error       : lt_error;
    m_success       = m_darkMode ? dk_success     : lt_success;
    m_info          = m_darkMode ? dk_info        : lt_info;
    m_gradientOuter = m_darkMode ? dk_gradOuter   : lt_gradOuter;
    m_gradientInner = m_darkMode ? dk_gradInner   : lt_gradInner;
    emit themeChanged();
}