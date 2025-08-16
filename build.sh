#!/usr/bin/env bash
set -e

PROJECT_ROOT="$(cd "$(dirname "$0")" && pwd)"
BUILD_DIR="$PROJECT_ROOT/build"

# Safety: refuse to build if an in-source build exists
if [ -f "$PROJECT_ROOT/Makefile" ] || [ -d "$PROJECT_ROOT/CMakeFiles" ]; then
    echo "Error: In-source CMake files found in project root."
    echo "Run: rm -rf Makefile cmake_install.cmake CMakeFiles CMakeCache.txt"
    exit 1
fi

# Clean build directory
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

# Detect Qt
if pkg-config --exists Qt6Core; then
    cmake "$PROJECT_ROOT" -DCMAKE_PREFIX_PATH=$(pkg-config --variable=libdir Qt6Core)/cmake/Qt6
else
    cmake "$PROJECT_ROOT" -DCMAKE_PREFIX_PATH=$(pkg-config --variable=libdir Qt5Core)/cmake/Qt5
fi

cmake --build . -j"$(nproc)"

# make run.sh executable
chmod +x "$PROJECT_ROOT/run.sh"