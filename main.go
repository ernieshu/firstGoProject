package main

import (
	"flag"
	"fmt"
	"os"
	"regexp"
	"strings"
)

// ValidateEmail checks if an email address is valid
// Uses regex pattern to validate basic email format
func ValidateEmail(email string) bool {
	// Trim whitespace
	email = strings.TrimSpace(email)

	// Basic email regex pattern
	// This pattern checks for: local@domain.extension
	pattern := `^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$`
	re := regexp.MustCompile(pattern)

	return re.MatchString(email)
}

func main() {
	// Define command-line flags
	flag.Usage = func() {
		fmt.Fprintf(os.Stderr, "Usage: %s [OPTIONS] email\n", os.Args[0])
		fmt.Fprintf(os.Stderr, "\nValidate email addresses from the command line.\n\n")
		fmt.Fprintf(os.Stderr, "Arguments:\n")
		fmt.Fprintf(os.Stderr, "  email   Email address to validate\n\n")
		fmt.Fprintf(os.Stderr, "Options:\n")
		flag.PrintDefaults()
	}

	// Parse command-line flags
	flag.Parse()

	// Get remaining arguments (the email address)
	args := flag.Args()

	if len(args) == 0 {
		fmt.Fprintf(os.Stderr, "Error: email address required\n")
		flag.Usage()
		os.Exit(1)
	}

	email := args[0]

	// Validate the email
	if ValidateEmail(email) {
		fmt.Printf("✅ Valid: %s\n", email)
		os.Exit(0)
	} else {
		fmt.Printf("❌ Invalid: %s\n", email)
		os.Exit(1)
	}
}
