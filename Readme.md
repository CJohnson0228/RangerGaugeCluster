# Ranger HMI

A custom automotive-grade infotainment and gauge cluster system built for a 2006 Ford Ranger Sport. Designed to replace the factory head unit with a modern HMI running on embedded Linux hardware, featuring a 15.6" OLED touchscreen in portrait orientation mounted in a custom center console.

---

## Overview

The system runs as a single Qt Quick/QML + C++ application with three independent windows — a gauge cluster display, an infotainment display, and a developer panel — all sharing a common C++ backend via Qt context properties. The UI targets an automotive-grade aesthetic using a McLaren Orange and black color scheme with glassmorphic panel design.

---

## Screenshots
![Gauge Cluster Light](screenshots/Screenshot%20from%202026-03-03%2017-38-45.png)
![Gauge Cluster Dark](screenshots/Screenshot%20from%202026-03-03%2017-37-49.png)
![Full HMI light](screenshots/Screenshot%20from%202026-03-03%2020-58-40.png)
![Full HMI dark](screenshots/Screenshot%20from%202026-03-03%2020-52-45.png)

---

## Hardware (Target)

| Component | Details |
|---|---|
| Head Unit | Bmax B7A Pro Mini PC — AMD Ryzen 5 7430U |
| Display | INNOCN PU15 Pre C6 — 15.6" OLED, 4K, 100% DCI-P3, portrait mount |
| OS | Linux (kiosk mode) |
| Vehicle | 2006 Ford Ranger Sport |
| OBD-II | ISO 9141-2 / KWP2000 (no CAN bus) |
| Hardware Bridge | Raspberry Pi → Arduino/ESP32 for HVAC and sensor integration |
| Audio | JBL 4-channel amplifier, component + coaxial speakers, subwoofer |

---

## Software Stack

| Layer | Technology |
|---|---|
| UI Framework | Qt 6.10 / Qt Quick / QML |
| Backend | C++ with Qt's Q_PROPERTY / signal-slot system |
| Build System | CMake 4.1 |
| Controls Style | Qt Quick Controls 2 — Basic (unstyled, fully custom) |
| Weather | Open-Meteo API via QNetworkAccessManager |
| OBD-II (planned) | ISO 9141-2 / KWP2000 |
| Cellular (planned) | USB modem via Linux ModemManager + NetworkManager |

---

## Architecture

### Three-Window Model

The application instantiates three independent `QQmlApplicationEngine` instances at startup, each targeting a dedicated display output in production:

```
main.cpp
├── gaugeClusterEngine    → ClusterView.qml    (factory instrument panel display)
├── infotainmentEngine    → InfotainmentView.qml (15.6" OLED center console)
└── devPanelEngine        → DevPanel.qml        (development controls, always visible)
```

### Shared C++ Services

All three engines share the same C++ object instances registered as context properties, enabling true cross-window state synchronization:

```
VehicleState   — vehicle data (speed, RPM, tire pressure, fuel economy, turn signals)
ThemeService   — theming (dark/light mode, color palette, fonts, resource paths)
```

When `DevPanel` writes `vehicleState.engineRPM = 3500`, both `ClusterView` and `InfotainmentView` update simultaneously because they hold pointers to the same C++ object in process memory.

### Data Flow

```
[Future: OBD-II / RPi sensors] → VehicleState (C++) → QML property bindings → UI
[Future: Sunrise/sunset API]   → ThemeService (C++) → QML color bindings   → UI
```

Hardcoded default values in `VehicleState` and `ThemeService` stand in for hardware data during UI development. When the backend arrives, only the data source changes — the QML layer requires no modification.

---

## Project Structure

```
HMItestground/
├── src/
│   ├── main.cpp
│   ├── VehicleState.h / .cpp    # Vehicle data service
│   └── ThemeService.h  / .cpp   # Theme and color service
├── qml/
│   ├── ClusterView.qml          # Gauge cluster root window
│   ├── InfotainmentView.qml     # Infotainment root window
│   ├── DevPanel.qml             # Developer control panel
│   ├── Speedo.qml               # Speedometer dial component
│   ├── Tach.qml                 # Tachometer dial component
│   ├── InstrumentData.qml       # Center cluster data display
│   ├── AmbientBackground.qml    # Crossfading background images
│   ├── WarningIndicators.qml    # Warning light row
│   └── UI/
│       ├── TurnSignal.qml
│       ├── WarningIndicator.qml
│       └── Data/
│           ├── Media.qml
│           ├── VehicleData.qml
│           ├── TirePressReading.qml
│           ├── Settings.qml
│           └── DataIcon.qml
├── resources/
│   ├── fonts/                   # Quicksand, Oxanium, BigShoulders
│   ├── icons/                   # SVG warning and UI icons
│   └── images/                  # Ambient background images (dark/light)
└── CMakeLists.txt
```

---

## Key Design Decisions

**Raw units in the data model.** `VehicleState` stores `engineRPM` as a raw value (e.g. `2200`). Display transformation (`/ 1000` for the tach dial) happens at the component level, keeping the data model hardware-compatible without translation.

**Glassmorphic UI.** Panel blur effects use Qt's `MultiEffect` with `ShaderEffectSource` targeting `themeService.backgroundItem`, which holds a reference to the ambient background `Item` set at runtime.

**No CAN bus.** The 2006 Ranger predates CAN bus. Vehicle data is sourced via OBD-II (ISO 9141-2/KWP2000) and direct electrical connections, interfaced through a Raspberry Pi bridge to the main PC.

**HVAC automation (planned).** Existing HVAC knobs will be retained and coupled to NEMA 17 stepper motors via standard lead screw couplings, controlled by Arduino with DS18B20 temperature sensors and limit switches for homing — reusing RepRap 3D printer components.

---

## Development Status

- [x] Gauge cluster UI — speedometer, tachometer, turn signals, warning indicators
- [x] Shared C++ services — VehicleState, ThemeService
- [x] Dark / light theme with crossfade animations
- [x] Developer panel with live value simulation
- [ ] Infotainment UI — navigation, media, climate
- [ ] OBD-II backend integration
- [ ] Weather service integration
- [ ] Cellular connectivity
- [ ] HVAC stepper motor control
- [ ] Sunrise/sunset automatic theme switching
- [ ] Deployment to target hardware (Bmax B7A Pro + INNOCN display)

---

## Requirements

- Qt 6.10+
- CMake 4.1+
- GCC / Clang with C++17
- Qt modules: Quick, QuickControls2, Quick3D, Network, Sql, Svg