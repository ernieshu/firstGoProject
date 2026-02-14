#!/bin/zsh

# Build script for email-validator CLI
# This script compiles the Go project into a binary

set -e

echo "Building email-validator..."

# Build the project
go build -o bin/email-validator .

echo "Build complete! Binary created at: ./bin/email-validator"
