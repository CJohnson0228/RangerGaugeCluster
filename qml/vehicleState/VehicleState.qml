pragma Singleton
import QtQuick
import HMItestUI

QtObject {
    id: root
    property int tirePressLF: 32
    property int tirePressRF: 32
    property int tirePressLR: 32
    property int tirePressRR: 32
    property real vehicleSpeed: 54
    property real engineRPM: 2.2
    property real fuelEconomyLive: 0
    property real fuelEconomyAverage: 18.6
    property real tripAmileage: 0
    property real tripBmileage: 0
    property bool leftTurnActive: false
    property bool rightTurnActive: false
    property int activeDataIndex: 0
    property string mediaSourceImage: "tool.jpg"
    property string mediaBandName: "Tool"
    property string mediaSongName: "Sober"
}