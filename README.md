# Email Validator CLI

A command-line tool written in Go to check the validity of email addresses.

## Overview

This project provides a simple command-line interface for validating email addresses. It performs syntax and format checks to ensure email addresses meet standard requirements.

## Project Structure

- `main.go` - Main entry point and email validation logic
- `main_test.go` - Unit tests for the validation functions
- `build.sh` - ZSH build script to compile the project
- `go.mod` - Go module definition

## Building

To build the project for all platforms, run:

```bash
./build.sh
```

This will create platform-specific binaries in the `bin/` directory:
- `email-validator-macos-amd64` - macOS (Intel)
- `email-validator-macos-arm64` - macOS (Apple Silicon)
- `email-validator-linux-amd64` - Linux
- `email-validator-windows-amd64.exe` - Windows

## Testing

To run the unit tests:

```bash
go test -v
```

## Usage

Once built, you can validate email addresses using the CLI:

```bash
./bin/email-validator <email>
```

## Development

The project is scaffolded and ready for implementation. Key areas to develop:

1. **Email Validation Logic** - Implement the `ValidateEmail()` function in `main.go`
2. **CLI Interface** - Add command-line argument parsing in the `main()` function
3. **Unit Tests** - Add comprehensive test cases in `main_test.go`

## Requirements

- Go 1.21 or higher
- ZSH shell (for the build script)

## License

MIT
