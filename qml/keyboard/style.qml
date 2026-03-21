import QtQuick
import QtQuick.VirtualKeyboard.Styles

KeyboardStyle {
    id: currentStyle

    // ── Design dimensions (scaleHint = keyboardHeight / keyboardDesignHeight) ─
    keyboardDesignWidth:  2560
    keyboardDesignHeight: 800

    // ── Theme colors ──────────────────────────────────────────────────────────
    readonly property bool isDark: (typeof themeService !== "undefined")
                                   ? themeService.darkMode : true

    readonly property color c_boardBg:  isDark ? "#0d0c0c" : "#f0f0f0"
    readonly property color c_keyBg:    isDark ? "#151314" : "#eaeceb"
    readonly property color c_fnKeyBg:  isDark ? "#1e1d1d" : "#d5d6d6"
    readonly property color c_border:   isDark ? "#2a2a2a" : "#c0c0c0"
    readonly property color c_keyText:  isDark ? "#fdfdfd" : "#030303"
    readonly property color c_fnText:   isDark ? "#ababab" : "#555555"
    readonly property color c_pressed:  isDark ? "#ff9d11" : "#ffbf66"
    readonly property color c_accent:   isDark ? "#ff9d11" : "#ffbf66"
    readonly property string kFont: (typeof themeService !== "undefined")
                                    ? themeService.fontQuicksand : ""

    // ── Keyboard background ───────────────────────────────────────────────────
    keyboardBackground: Rectangle {
        color: c_boardBg
        Rectangle {
            anchors.top: parent.top
            width: parent.width
            height: 3
            color: c_accent
            opacity: 0.8
        }
    }

    // ── Generic key (renders background + label + small hint text) ────────────
    keyPanel: KeyPanel {
        Rectangle {
            anchors.fill: parent
            anchors.margins: Math.round(6 * scaleHint)
            radius: Math.round(8 * scaleHint)
            color: control.pressed ? c_pressed : c_keyBg
            border.color: control.pressed ? c_pressed : c_border
            border.width: 1
            Behavior on color { ColorAnimation { duration: 70 } }
            Text {
                anchors.centerIn: parent
                text: control.displayText
                color: control.pressed ? "#000000" : c_keyText
                font.family: kFont
                font.pixelSize: Math.round(44 * scaleHint)
                font.weight: Font.Medium
                Behavior on color { ColorAnimation { duration: 70 } }
            }
            Text {
                anchors { right: parent.right; top: parent.top; margins: Math.round(6 * scaleHint) }
                text: control.smallText
                visible: control.smallTextVisible
                color: c_fnText
                font.family: kFont
                font.pixelSize: Math.round(22 * scaleHint)
            }
        }
    }

    // ── Backspace ─────────────────────────────────────────────────────────────
    backspaceKeyPanel: KeyPanel {
        Rectangle {
            anchors.fill: parent
            anchors.margins: Math.round(6 * scaleHint)
            radius: Math.round(8 * scaleHint)
            color: control.pressed ? c_pressed : c_fnKeyBg
            border.color: control.pressed ? c_pressed : c_border
            border.width: 1
            Behavior on color { ColorAnimation { duration: 70 } }
            Text {
                anchors.centerIn: parent
                text: "⌫"
                color: control.pressed ? "#000000" : c_fnText
                font.pixelSize: Math.round(42 * scaleHint)
                Behavior on color { ColorAnimation { duration: 70 } }
            }
        }
    }

    // ── Enter ─────────────────────────────────────────────────────────────────
    enterKeyPanel: KeyPanel {
        Rectangle {
            anchors.fill: parent
            anchors.margins: Math.round(6 * scaleHint)
            radius: Math.round(8 * scaleHint)
            color: control.pressed ? "#cc7d00" : c_accent
            border.color: control.pressed ? "#cc7d00" : c_accent
            border.width: 1
            Behavior on color { ColorAnimation { duration: 70 } }
            Text {
                anchors.centerIn: parent
                text: "↵"
                color: "#000000"
                font.pixelSize: Math.round(42 * scaleHint)
                font.weight: Font.Medium
            }
        }
    }

    // ── Hide keyboard ─────────────────────────────────────────────────────────
    hideKeyPanel: KeyPanel {
        Rectangle {
            anchors.fill: parent
            anchors.margins: Math.round(6 * scaleHint)
            radius: Math.round(8 * scaleHint)
            color: control.pressed ? c_pressed : c_fnKeyBg
            border.color: control.pressed ? c_pressed : c_border
            border.width: 1
            Behavior on color { ColorAnimation { duration: 70 } }
            Text {
                anchors.centerIn: parent
                text: "⌨"
                color: control.pressed ? "#000000" : c_fnText
                font.pixelSize: Math.round(36 * scaleHint)
                Behavior on color { ColorAnimation { duration: 70 } }
            }
        }
    }

    // ── Shift ─────────────────────────────────────────────────────────────────
    shiftKeyPanel: KeyPanel {
        Rectangle {
            anchors.fill: parent
            anchors.margins: Math.round(6 * scaleHint)
            radius: Math.round(8 * scaleHint)
            color: control.pressed ? c_pressed : c_fnKeyBg
            border.color: control.pressed ? c_pressed : c_border
            border.width: 1
            Behavior on color { ColorAnimation { duration: 70 } }
            Text {
                anchors.centerIn: parent
                text: "⇧"
                color: control.pressed ? "#000000" : c_fnText
                font.pixelSize: Math.round(42 * scaleHint)
                Behavior on color { ColorAnimation { duration: 70 } }
            }
        }
    }

    // ── Space bar (accent border) ─────────────────────────────────────────────
    spaceKeyPanel: KeyPanel {
        Rectangle {
            anchors.fill: parent
            anchors.margins: Math.round(6 * scaleHint)
            radius: Math.round(8 * scaleHint)
            color: control.pressed ? c_pressed : c_fnKeyBg
            border.color: control.pressed ? c_pressed : c_accent
            border.width: 1
            Behavior on color { ColorAnimation { duration: 70 } }
            Text {
                anchors.centerIn: parent
                text: control.displayText
                color: control.pressed ? "#000000" : c_fnText
                font.family: kFont
                font.pixelSize: Math.round(28 * scaleHint)
                opacity: 0.7
                Behavior on color { ColorAnimation { duration: 70 } }
            }
        }
    }

    // ── Symbol mode toggle (?123 / ABC) ───────────────────────────────────────
    symbolKeyPanel: KeyPanel {
        Rectangle {
            anchors.fill: parent
            anchors.margins: Math.round(6 * scaleHint)
            radius: Math.round(8 * scaleHint)
            color: control.pressed ? c_pressed : c_fnKeyBg
            border.color: control.pressed ? c_pressed : c_border
            border.width: 1
            Behavior on color { ColorAnimation { duration: 70 } }
            Text {
                anchors.centerIn: parent
                text: control.displayText
                color: control.pressed ? "#000000" : c_fnText
                font.family: kFont
                font.pixelSize: Math.round(30 * scaleHint)
                font.weight: Font.Medium
                Behavior on color { ColorAnimation { duration: 70 } }
            }
        }
    }

    // ── Mode key (generic on/off toggle) ─────────────────────────────────────
    modeKeyPanel: KeyPanel {
        Rectangle {
            anchors.fill: parent
            anchors.margins: Math.round(6 * scaleHint)
            radius: Math.round(8 * scaleHint)
            color: control.pressed ? c_pressed : c_fnKeyBg
            border.color: control.pressed ? c_pressed : c_border
            border.width: 1
            Behavior on color { ColorAnimation { duration: 70 } }
            Text {
                anchors.centerIn: parent
                text: control.displayText
                color: control.pressed ? "#000000" : c_fnText
                font.family: kFont
                font.pixelSize: Math.round(30 * scaleHint)
                Behavior on color { ColorAnimation { duration: 70 } }
            }
        }
    }

    // ── Language key ──────────────────────────────────────────────────────────
    languageKeyPanel: KeyPanel {
        Rectangle {
            anchors.fill: parent
            anchors.margins: Math.round(6 * scaleHint)
            radius: Math.round(8 * scaleHint)
            color: control.pressed ? c_pressed : c_fnKeyBg
            border.color: control.pressed ? c_pressed : c_border
            border.width: 1
            Behavior on color { ColorAnimation { duration: 70 } }
            Text {
                anchors.centerIn: parent
                text: control.displayText
                color: control.pressed ? "#000000" : c_fnText
                font.family: kFont
                font.pixelSize: Math.round(28 * scaleHint)
                Behavior on color { ColorAnimation { duration: 70 } }
            }
        }
    }

    // ── Handwriting key ───────────────────────────────────────────────────────
    handwritingKeyPanel: KeyPanel {
        Rectangle {
            anchors.fill: parent
            anchors.margins: Math.round(6 * scaleHint)
            radius: Math.round(8 * scaleHint)
            color: control.pressed ? c_pressed : c_fnKeyBg
            border.color: control.pressed ? c_pressed : c_border
            border.width: 1
            Behavior on color { ColorAnimation { duration: 70 } }
            Text {
                anchors.centerIn: parent
                text: "✍"
                color: control.pressed ? "#000000" : c_fnText
                font.pixelSize: Math.round(38 * scaleHint)
                Behavior on color { ColorAnimation { duration: 70 } }
            }
        }
    }

    // ── Character preview bubble ──────────────────────────────────────────────
    characterPreviewMargin: Math.round(10 * scaleHint)
    characterPreviewDelegate: Item {
        property string text
        Rectangle {
            anchors.fill: parent
            radius: Math.round(10 * scaleHint)
            color: c_accent
            Text {
                anchors.centerIn: parent
                text: parent.parent.text
                color: "#000000"
                font.family: kFont
                font.pixelSize: Math.round(56 * scaleHint)
                font.weight: Font.Medium
            }
        }
    }

    // ── Alternate keys popup ──────────────────────────────────────────────────
    alternateKeysListItemWidth:  Math.round(60 * scaleHint)
    alternateKeysListItemHeight: Math.round(90 * scaleHint)
    alternateKeysListTopMargin:    Math.round(6 * scaleHint)
    alternateKeysListBottomMargin: Math.round(6 * scaleHint)
    alternateKeysListLeftMargin:   Math.round(6 * scaleHint)
    alternateKeysListRightMargin:  Math.round(6 * scaleHint)

    alternateKeysListDelegate: Item {
        id: altKeyItem
        property string text
        property bool highlight
        Text {
            anchors.centerIn: parent
            text: altKeyItem.text
            color: altKeyItem.highlight ? c_accent : c_keyText
            font.family: kFont
            font.pixelSize: Math.round(38 * scaleHint)
        }
    }
    alternateKeysListHighlight: Rectangle {
        radius: Math.round(4 * scaleHint)
        color: Qt.rgba(1, 1, 1, 0.1)
    }
    alternateKeysListBackground: Rectangle {
        radius: Math.round(8 * scaleHint)
        color: c_keyBg
        border.color: c_accent
        border.width: 1
    }

    // ── Selection handle ──────────────────────────────────────────────────────
    selectionHandle: Rectangle {
        width:  Math.round(20 * scaleHint)
        height: Math.round(20 * scaleHint)
        radius: Math.round(10 * scaleHint)
        color: c_accent
    }

    // ── Word suggestion list ───────────────────────────────────────────────────
    selectionListHeight: Math.round(85 * scaleHint)

    selectionListDelegate: Item {
        id: selItem
        property string text
        property bool highlight
        Text {
            anchors.centerIn: parent
            text: selItem.text
            color: selItem.highlight ? c_accent : c_keyText
            font.family: kFont
            font.pixelSize: Math.round(32 * scaleHint)
        }
    }
    selectionListHighlight: Rectangle {
        radius: Math.round(4 * scaleHint)
        color: Qt.rgba(1, 1, 1, 0.1)
    }
    selectionListBackground: Rectangle {
        color: c_boardBg
        Rectangle {
            anchors.bottom: parent.bottom
            width: parent.width
            height: 1
            color: c_border
        }
    }
    selectionListAdd: Transition {
        NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 150 }
    }
    selectionListRemove: Transition {
        NumberAnimation { property: "opacity"; to: 0; duration: 150 }
    }

    // ── Navigation highlight ──────────────────────────────────────────────────
    navigationHighlight: Rectangle {
        radius: Math.round(8 * scaleHint)
        color: "transparent"
        border.color: c_accent
        border.width: 2
    }

    // ── Popup list (language suggestions etc.) ────────────────────────────────
    popupListDelegate: Item {
        id: popItem
        property string text
        property bool highlight
        Text {
            anchors.centerIn: parent
            text: popItem.text
            color: popItem.highlight ? c_accent : c_keyText
            font.family: kFont
            font.pixelSize: Math.round(32 * scaleHint)
        }
    }
    popupListHighlight: Rectangle {
        radius: Math.round(4 * scaleHint)
        color: Qt.rgba(1, 1, 1, 0.1)
    }
    popupListBackground: Rectangle {
        radius: Math.round(8 * scaleHint)
        color: c_keyBg
        border.color: c_accent
        border.width: 1
    }
    popupListAdd: Transition {
        NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 100 }
    }
    popupListRemove: Transition {
        NumberAnimation { property: "opacity"; to: 0; duration: 100 }
    }

    // ── Language list ─────────────────────────────────────────────────────────
    languageListDelegate: Item {
        id: langItem
        property string text
        property bool highlight
        Text {
            anchors.centerIn: parent
            text: langItem.text
            color: langItem.highlight ? c_accent : c_keyText
            font.family: kFont
            font.pixelSize: Math.round(32 * scaleHint)
        }
    }
    languageListHighlight: Rectangle {
        radius: Math.round(4 * scaleHint)
        color: Qt.rgba(1, 1, 1, 0.1)
    }
    languageListBackground: Rectangle {
        radius: Math.round(8 * scaleHint)
        color: c_keyBg
        border.color: c_border
        border.width: 1
    }
    languageListAdd: Transition {
        NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 100 }
    }
    languageListRemove: Transition {
        NumberAnimation { property: "opacity"; to: 0; duration: 100 }
    }

    // ── Function popup list (long-press function key) ─────────────────────────
    functionPopupListDelegate: Item {
        id: fnPopItem
        property int keyboardFunction
        property bool highlight
        Rectangle {
            anchors.fill: parent
            anchors.margins: Math.round(4 * scaleHint)
            radius: Math.round(6 * scaleHint)
            color: fnPopItem.highlight ? c_accent : "transparent"
            Text {
                anchors.centerIn: parent
                text: fnPopItem.keyboardFunction
                color: fnPopItem.highlight ? "#000000" : c_keyText
                font.family: kFont
                font.pixelSize: Math.round(28 * scaleHint)
            }
        }
    }
    functionPopupListHighlight: Rectangle {
        radius: Math.round(4 * scaleHint)
        color: Qt.rgba(1, 1, 1, 0.1)
    }
    functionPopupListBackground: Rectangle {
        radius: Math.round(8 * scaleHint)
        color: c_keyBg
        border.color: c_border
        border.width: 1
    }

    // ── Full-screen input (not used in this app but must not be null) ─────────
    fullScreenInputContainerBackground: Rectangle { color: c_boardBg }
    fullScreenInputBackground: Rectangle { color: c_keyBg; radius: Math.round(6 * scaleHint) }
    fullScreenInputMargins: Math.round(10 * scaleHint)
    fullScreenInputPadding: Math.round(10 * scaleHint)
    fullScreenInputCursor: Rectangle {
        width: 2
        color: c_accent
        visible: parent.blinkStatus
    }
    fullScreenInputFont.family: kFont
    fullScreenInputFont.pixelSize: Math.round(44 * scaleHint)
    fullScreenInputColor: c_keyText
    fullScreenInputSelectionColor: Qt.rgba(c_accent.r, c_accent.g, c_accent.b, 0.4)
    fullScreenInputSelectedTextColor: "#000000"
}
