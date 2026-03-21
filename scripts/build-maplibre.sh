#!/usr/bin/env bash
# Build maplibre-native-qt as a proper external dependency and install to ~/Qt/maplibre-qt
#
# Run once from any directory:
#   bash /mnt/sda1/cppprojects/HMItestground/scripts/build-maplibre.sh
#
# On car hardware: re-run this script targeting that platform's Qt install,
# adjusting QT_DIR below.

set -e

QT_DIR="$HOME/Qt/6.10.2/gcc_64"
CMAKE="/home/chris/.local/share/JetBrains/Toolbox/apps/clion/bin/cmake/linux/x64/bin/cmake"
NINJA="/home/chris/.local/share/JetBrains/Toolbox/apps/clion/bin/ninja/linux/x64/ninja"
INSTALL_PREFIX="$HOME/Qt/maplibre-qt"
SOURCE_DIR="$HOME/Qt/maplibre-native-qt-src"
BUILD_DIR="$HOME/Qt/maplibre-native-qt-build"

# ── 1. Clone ─────────────────────────────────────────────────────────────────
if [ ! -d "$SOURCE_DIR" ]; then
    echo "==> Cloning maplibre-native-qt..."
    git clone --recurse-submodules \
        https://github.com/maplibre/maplibre-native-qt.git \
        "$SOURCE_DIR"
else
    echo "==> Source already exists at $SOURCE_DIR — skipping clone."
    echo "    To update: cd $SOURCE_DIR && git pull && git submodule update --init --recursive"
fi

# ── 2. Patch: SharedGLContext (required when running inside Qt Quick) ─────────
PATCH_FILE="$SOURCE_DIR/src/quick/plugins/map_quick_item.cpp"
if ! grep -q "SharedGLContext" "$PATCH_FILE"; then
    echo "==> Applying SharedGLContext patch..."
    sed -i 's/m_settings\.setCacheDatabasePath(QStringLiteral(":memory:"));/m_settings.setContextMode(Settings::SharedGLContext);\n    m_settings.setCacheDatabasePath(QStringLiteral(":memory:"));/' \
        "$PATCH_FILE"
    echo "    Done."
else
    echo "==> SharedGLContext patch already applied."
fi

# ── 3. Configure ─────────────────────────────────────────────────────────────
echo "==> Configuring..."
mkdir -p "$BUILD_DIR"
"$CMAKE" -S "$SOURCE_DIR" -B "$BUILD_DIR" \
    -G Ninja \
    -DCMAKE_MAKE_PROGRAM="$NINJA" \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX="$INSTALL_PREFIX" \
    -DCMAKE_PREFIX_PATH="$QT_DIR" \
    -DCMAKE_CXX_STANDARD=20 \
    -DCMAKE_INSTALL_RPATH="$INSTALL_PREFIX/lib" \
    -DCMAKE_INSTALL_RPATH_USE_LINK_PATH=ON \
    -DMLN_QT_WITH_QUICK=ON \
    -DMLN_QT_WITH_LOCATION=ON \
    -DMLN_QT_WITH_WIDGETS=OFF \
    -DMLN_WITH_OPENGL=ON \
    -DMLN_WITH_WERROR=OFF

# ── 4. Build ──────────────────────────────────────────────────────────────────
echo "==> Building (this will take 20-40 minutes)..."
"$CMAKE" --build "$BUILD_DIR" --parallel "$(nproc)"

# ── 5. Install ────────────────────────────────────────────────────────────────
echo "==> Installing to $INSTALL_PREFIX..."
"$CMAKE" --install "$BUILD_DIR"

echo ""
echo "Done. maplibre-native-qt installed to: $INSTALL_PREFIX"
echo ""
echo "In CLion CMake settings, ensure CMAKE_PREFIX_PATH includes:"
echo "  $QT_DIR;$INSTALL_PREFIX"
echo ""
echo "Then do a Clean CMake Cache and Reconfigure in CLion."
