pragma Singleton
import QtQuick

Item {
    property bool isDarkMode: sensorDarkMode
    onIsDarkModeChanged: applyTheme()
    Component.onCompleted: applyTheme()

    // UI Background
    property Item backgroundItem: null

    // Resource Paths
    readonly property string resourcePath: "qrc:/qt/qml/HMItestUI/resources/"
    readonly property string iconPath: resourcePath + "icons/"
    readonly property string fontPath: resourcePath + "fonts/"
    readonly property string imagePath: resourcePath + "images/"

    // Theme Toggle Function
    function applyTheme() {
        background = isDarkMode ? darkBackground : lightBackground
        foreground = isDarkMode ? darkForeground : lightForeground
        card = isDarkMode ? darkCard : lightCard
        paper = isDarkMode ? darkPaper : lightPaper
        muted = isDarkMode ? darkMuted : lightMuted
        textMuted = isDarkMode ? darkTextMuted : lightTextMuted
        border = isDarkMode ? darkBorder : lightBorder
        input = isDarkMode ? darkInput : lightInput
        ring = isDarkMode ? darkRing : lightRing
        primary = isDarkMode ? darkPrimary : lightPrimary
        accent = isDarkMode ? darkAccent : lightAccent
        error = isDarkMode ? darkError : lightError
        themeSuccess = isDarkMode ? darkSuccess : lightSuccess
        themeInfo = isDarkMode ? darkInfo : lightInfo
        themeGradientOuter = isDarkMode ? darkGradientOuter : lightGradientOuter
        themeGradientInner = isDarkMode ? darkGradientInner : lightGradientInner
        console.log("Theme applied, dark mode: " + isDarkMode + ", bg: " + background)
    }
    readonly property real toggleTimer: 500

    // Dark Base Colors
    readonly property color darkBackground: "#000000"
    readonly property color darkForeground: "#fdfdfd"
    readonly property color darkCard: "#151314"
    readonly property color darkPaper: "#1c1c1c"
    readonly property color darkMuted: "#343434"
    readonly property color darkTextMuted: "#ababab"
    readonly property color darkBorder: "#333333"
    readonly property color darkInput: "#111111"
    readonly property color darkRing: "#555555"
    readonly property color darkGradientOuter: "#191818"
    readonly property color darkGradientInner: "#0b0a0a"

    // Light Base Colors
    readonly property color lightBackground: "#ffffff"
    readonly property color lightForeground: "#030303"
    readonly property color lightCard: "#eaeceb"
    readonly property color lightPaper: "#e3e3e3"
    readonly property color lightMuted: "#9a9a9a"
    readonly property color lightTextMuted: "#454545"
    readonly property color lightBorder: "#cccccc"
    readonly property color lightInput: "#eeeeee"
    readonly property color lightRing: "#aaaaaa"
    readonly property color lightGradientOuter: "#e6e7e7"
    readonly property color lightGradientInner: "#f4f5f5"

    // Primary
    readonly property color darkPrimary: "#ff9d11"
    readonly property color lightPrimary: "#ffbf66"

    // Accent
    readonly property color darkAccent: "#ffd911"
    readonly property color lightAccent: "#ffe975"

    // Error
    readonly property color darkError: "#ff2612"
    readonly property color lightError: "#f54d3d"

    // success
    readonly property color darkSuccess: "#27E853"
    readonly property color lightSuccess: "#27E853"

    // Info
    readonly property color darkInfo: "#4782e4"
    readonly property color lightInfo: "#7AA5EB"

    // Dynamic Properties
    property color background: darkBackground
    property color foreground: darkForeground
    property color card: darkCard
    property color paper: darkPaper
    property color muted: darkMuted
    property color textMuted: darkTextMuted
    property color border: darkBorder
    property color input: darkInput
    property color ring: darkRing
    property color primary: darkPrimary
    property color accent: darkAccent
    property color error: darkError
    property color themeSuccess: darkSuccess
    property color themeInfo: darkInfo
    property color themeGradientOuter: darkGradientOuter
    property color themeGradientInner: darkGradientInner

    // Fonts
    FontLoader {
        id: quicksand
        source: fontPath + "Quicksand.ttf"
    }
    FontLoader {
        id: oxanium
        source: fontPath + "Oxanium.ttf"
    }
    FontLoader {
        id: bigshoulders
        source: fontPath + "BigShoulders.ttf"
    }

    readonly property string fontQuicksand: quicksand.name
    readonly property string fontOxanium: oxanium.name
    readonly property string fontBigShoulders: bigshoulders.name
}