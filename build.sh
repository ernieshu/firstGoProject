#!/bin/zsh

# Build script for email-validator CLI
# This script compiles the Go project into binaries for multiple platforms:
# - macOS (Intel - amd64)
# - macOS (Apple Silicon - arm64)
# - Linux (amd64)
# - Windows (amd64)
#
# Pre-build: Runs unit tests and verifies they pass
# Post-build: Verifies the built CLI with test cases

set -e

# ============================================================================
# DEPENDENCY CHECK: Verify Go is installed
# ============================================================================
if ! command -v go &> /dev/null; then
    echo "⚠️  Go is not installed on this system."
    echo ""
    
    if ! command -v brew &> /dev/null; then
        echo "❌ Homebrew is also not installed."
        echo "Please install Go from: https://golang.org/dl"
        echo "Or install Homebrew first: https://brew.sh"
        exit 1
    fi
    
    echo "📦 Installing Go via Homebrew..."
    brew install go
    
    if command -v go &> /dev/null; then
        echo "✅ Go installed successfully!"
        echo ""
    else
        echo "❌ Failed to install Go via Homebrew"
        exit 1
    fi
fi

echo "✅ Go is installed ($(go version))"
echo ""

# Define build targets
declare -a TARGETS=(
    "darwin:amd64:email-validator-macos-amd64"
    "darwin:arm64:email-validator-macos-arm64"
    "linux:amd64:email-validator-linux-amd64"
    "windows:amd64:email-validator-windows-amd64.exe"
)

# ============================================================================
# STEP 1: Run unit tests
# ============================================================================
echo "🧪 Running unit tests..."
echo ""

if ! go test -v; then
    echo ""
    echo "❌ Unit tests failed! Build aborted."
    exit 1
fi

echo ""
echo "✅ All unit tests passed!"
echo ""

# ============================================================================
# STEP 2: Build binaries
# ============================================================================
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

# ============================================================================
# STEP 3: Verify built CLI
# ============================================================================
echo ""
echo "🔍 Verifying built CLI (macOS)..."
echo ""

# Detect macOS architecture
ARCH=$(uname -m)
if [[ "$ARCH" == "arm64" ]]; then
    MACOS_BINARY="./bin/email-validator-macos-arm64"
else
    MACOS_BINARY="./bin/email-validator-macos-amd64"
fi

# Test cases for verification
declare -a VALID_EMAILS=(
    "user@example.com"
    "john.doe@company.org"
    "test+tag@domain.co.uk"
)

declare -a INVALID_EMAILS=(
    "invalid-email"
    "@nodomain.com"
    "user@"
)

# Test valid emails
echo "Testing valid emails:"
for email in "${VALID_EMAILS[@]}"; do
    if $MACOS_BINARY "$email" > /dev/null 2>&1; then
        echo "  ✅ $email"
    else
        echo "  ❌ Failed to validate: $email"
        exit 1
    fi
done

echo ""
echo "Testing invalid emails:"
for email in "${INVALID_EMAILS[@]}"; do
    if ! $MACOS_BINARY "$email" > /dev/null 2>&1; then
        echo "  ✅ Correctly rejected: $email"
    else
        echo "  ❌ Failed to reject: $email"
        exit 1
    fi
done

echo ""
echo "🎉 CLI verification passed!"
echo ""
echo "Build and verification successful!"
