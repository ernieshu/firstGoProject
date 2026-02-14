#!/bin/zsh

# Build script for email-validator CLI
# This script compiles the Go project into binaries for multiple platforms:
# - macOS (Intel - amd64)
# - macOS (Apple Silicon - arm64)
# - Linux (amd64)
# - Windows (amd64)

set -e

# Define build targets
declare -a TARGETS=(
    "darwin:amd64:email-validator-macos-amd64"
    "darwin:arm64:email-validator-macos-arm64"
    "linux:amd64:email-validator-linux-amd64"
    "windows:amd64:email-validator-windows-amd64.exe"
)

echo "🔨 Building email-validator for multiple platforms..."
echo ""

# Clean previous builds
rm -rf bin

# Create bin directory
mkdir -p bin

# Build for each target
for target in "${TARGETS[@]}"; do
    IFS=':' read -r GOOS GOARCH output <<< "$target"
    
    echo "Building for $GOOS/$GOARCH..."
    GOOS=$GOOS GOARCH=$GOARCH go build -o bin/$output .
    echo "✅ Created: ./bin/$output"
done

echo ""
echo "✨ Build complete! All binaries created in ./bin/"
echo ""
echo "Available binaries:"
ls -lh bin/ | grep -v "^total" | awk '{print "  - " $9 " (" $5 ")"}'
