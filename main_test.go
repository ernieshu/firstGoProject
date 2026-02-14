package main

import "testing"

func TestValidateEmail(t *testing.T) {
	tests := []struct {
		email    string
		expected bool
		name     string
	}{
		// Valid emails
		{"user@example.com", true, "valid email"},
		{"john.doe@example.com", true, "email with dot in local part"},
		{"user+tag@example.co.uk", true, "email with plus sign and multi-level domain"},
		{"test_email@test-domain.com", true, "email with underscore and hyphen"},
		{"a@b.co", true, "minimal valid email"},

		// Invalid emails
		{"plainaddress", false, "no @ symbol"},
		{"@example.com", false, "missing local part"},
		{"user@", false, "missing domain"},
		{"user@.com", false, "missing domain name"},
		{"user@example", false, "missing top-level domain"},
		{"user@@example.com", false, "double @ symbol"},
		{"user @example.com", false, "space in local part"},
		{"user@exam ple.com", false, "space in domain"},
		{"user@example.c", false, "single character TLD"},
		{"", false, "empty string"},
		{"   ", false, "whitespace only"},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			result := ValidateEmail(tt.email)
			if result != tt.expected {
				t.Errorf("ValidateEmail(%q) = %v, want %v", tt.email, result, tt.expected)
			}
		})
	}
}
