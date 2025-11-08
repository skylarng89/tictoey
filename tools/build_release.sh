#!/bin/bash

# Auto-incrementing build script for TicToey
# Usage: ./tools/build_release.sh [version-type]

set -e

VERSION_FILE="pubspec.yaml"
BUILD_FILE="build/app/outputs/bundle/release/app-release.aab"

# Get current version
CURRENT_VERSION=$(grep "version:" $VERSION_FILE | cut -d' ' -f2)
CURRENT_NAME=$(echo $CURRENT_VERSION | cut -d'+' -f1)
CURRENT_CODE=$(echo $CURRENT_VERSION | cut -d'+' -f2)

echo "Current version: $CURRENT_VERSION"

# Determine version type
VERSION_TYPE=${1:-"patch"} # Default to patch

# Calculate new version
case $VERSION_TYPE in
    "patch")
        # Increment patch version: 1.0.0 -> 1.0.1
        MAJOR=$(echo $CURRENT_NAME | cut -d'.' -f1)
        MINOR=$(echo $CURRENT_NAME | cut -d'.' -f2)
        PATCH=$(echo $CURRENT_NAME | cut -d'.' -f3)
        NEW_PATCH=$((PATCH + 1))
        NEW_NAME="$MAJOR.$MINOR.$NEW_PATCH"
        ;;
    "minor")
        # Increment minor version: 1.0.1 -> 1.1.0
        MAJOR=$(echo $CURRENT_NAME | cut -d'.' -f1)
        MINOR=$(echo $CURRENT_NAME | cut -d'.' -f2)
        NEW_MINOR=$((MINOR + 1))
        NEW_NAME="$MAJOR.$NEW_MINOR.0"
        ;;
    "major")
        # Increment major version: 1.1.0 -> 2.0.0
        MAJOR=$(echo $CURRENT_NAME | cut -d'.' -f1)
        NEW_MAJOR=$((MAJOR + 1))
        NEW_NAME="$NEW_MAJOR.0.0"
        ;;
    "build")
        # Only increment build code: 1.0.0+2 -> 1.0.0+3
        NEW_NAME="$CURRENT_NAME"
        ;;
    *)
        echo "Usage: $0 [patch|minor|major|build]"
        echo "  patch  - Increment patch version (default)"
        echo "  minor  - Increment minor version"
        echo "  major  - Increment major version"
        echo "  build  - Only increment build code"
        exit 1
        ;;
esac

# Increment build code
NEW_CODE=$((CURRENT_CODE + 1))
NEW_VERSION="$NEW_NAME+$NEW_CODE"

echo "New version: $NEW_VERSION"

# Update pubspec.yaml
sed -i "s/version: $CURRENT_VERSION/version: $NEW_VERSION/" $VERSION_FILE

echo "✅ Version updated in pubspec.yaml"

# Clean and build
echo "🧹 Cleaning previous build..."
flutter clean

echo "📦 Getting dependencies..."
flutter pub get

echo "🔨 Building release bundle..."
flutter build appbundle --release

# Verify build
if [ -f "$BUILD_FILE" ]; then
    BUILD_SIZE=$(ls -lh $BUILD_FILE | cut -d' ' -f5)
    echo "✅ Build successful!"
    echo "📁 Bundle: $BUILD_FILE"
    echo "📊 Size: $BUILD_SIZE"
    echo "🎯 Ready for Google Play upload!"
    
    # Show certificate info
    echo ""
    echo "📋 Certificate Info:"
    keytool -printcert -jarfile $BUILD_FILE | grep -E "(Owner:|Valid from:)"
else
    echo "❌ Build failed!"
    exit 1
fi

echo ""
echo "🎉 Release build completed: $NEW_VERSION"
