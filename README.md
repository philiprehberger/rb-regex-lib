# philiprehberger-regex_lib

[![Tests](https://github.com/philiprehberger/rb-regex-lib/actions/workflows/ci.yml/badge.svg)](https://github.com/philiprehberger/rb-regex-lib/actions/workflows/ci.yml)
[![Gem Version](https://badge.fury.io/rb/philiprehberger-regex_lib.svg)](https://rubygems.org/gems/philiprehberger-regex_lib)
[![License](https://img.shields.io/github/license/philiprehberger/rb-regex-lib)](LICENSE)
[![Sponsor](https://img.shields.io/badge/sponsor-GitHub%20Sponsors-ec6cb9)](https://github.com/sponsors/philiprehberger)

Pre-built regex patterns for emails, URLs, IPs, dates, and more

## Requirements

- Ruby >= 3.1

## Installation

Add to your Gemfile:

```ruby
gem "philiprehberger-regex_lib"
```

Or install directly:

```bash
gem install philiprehberger-regex_lib
```

## Usage

```ruby
require "philiprehberger/regex_lib"

# Use patterns directly as constants
"user@example.com".match?(Philiprehberger::RegexLib::EMAIL)  # => true
"192.168.1.1".match?(Philiprehberger::RegexLib::IPV4)        # => true
```

### Validation with Helper

```ruby
Philiprehberger::RegexLib.match?(:email, "user@example.com")   # => true
Philiprehberger::RegexLib.match?(:url, "https://example.com")  # => true
Philiprehberger::RegexLib.match?(:ipv4, "999.999.999.999")     # => false
```

### Named Captures

```ruby
result = Philiprehberger::RegexLib.extract(:date_iso, "2026-03-26")
# => {"year"=>"2026", "month"=>"03", "day"=>"26"}

result = Philiprehberger::RegexLib.extract(:semantic_version, "1.2.3-alpha")
# => {"major"=>"1", "minor"=>"2", "patch"=>"3", "prerelease"=>"alpha", "buildmetadata"=>nil}
```

### Extracting All Matches

```ruby
text = "Contact hello@example.com or support@test.org"
Philiprehberger::RegexLib.extract_all(:email, text)
# => ["hello@example.com", "support@test.org"]
```

### Available Patterns

| Constant | Description |
|----------|-------------|
| `EMAIL` | Email address (local@domain.tld) |
| `URL` | HTTP/HTTPS URL |
| `IPV4` | IPv4 address (0-255 per octet) |
| `IPV6` | IPv6 address |
| `UUID` | UUID (8-4-4-4-12 hex) |
| `PHONE_E164` | E.164 phone number |
| `DATE_ISO` | ISO 8601 date with named captures (year, month, day) |
| `TIME_ISO` | ISO 8601 time (HH:MM:SS) |
| `DATETIME_ISO` | ISO 8601 datetime |
| `HEX_COLOR` | Hex color (#RGB or #RRGGBB) |
| `CREDIT_CARD` | Credit card number (13-19 digits) |
| `SSN` | US Social Security Number |
| `MAC_ADDRESS` | MAC address (colon or hyphen separated) |
| `SEMANTIC_VERSION` | SemVer with named captures (major, minor, patch, prerelease) |
| `SLUG` | URL slug (lowercase alphanumeric and hyphens) |

## API

| Method | Description |
|--------|-------------|
| `RegexLib.match?(pattern_name, string)` | Test string against a named pattern, returns `true`/`false` |
| `RegexLib.extract(pattern_name, string)` | Extract named captures as a `Hash`, or `nil` if no match |
| `RegexLib.extract_all(pattern_name, string)` | Find all matches in the string, returns `Array<String>` |

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

## License

[MIT](LICENSE)
