# philiprehberger-regex_lib

[![Tests](https://github.com/philiprehberger/rb-regex-lib/actions/workflows/ci.yml/badge.svg)](https://github.com/philiprehberger/rb-regex-lib/actions/workflows/ci.yml)
[![Gem Version](https://badge.fury.io/rb/philiprehberger-regex_lib.svg)](https://rubygems.org/gems/philiprehberger-regex_lib)
[![Last updated](https://img.shields.io/github/last-commit/philiprehberger/rb-regex-lib)](https://github.com/philiprehberger/rb-regex-lib/commits/main)

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

result = Philiprehberger::RegexLib.extract(:email, "user@example.com")
# => {"local"=>"user", "domain"=>"example.com"}

result = Philiprehberger::RegexLib.extract(:url, "https://example.com:8080/path?q=1#frag")
# => {"scheme"=>"https", "host"=>"example.com", "port"=>"8080", "path"=>"/path", "query"=>"q=1", "fragment"=>"frag"}

result = Philiprehberger::RegexLib.extract(:ipv4, "192.168.1.1")
# => {"octet1"=>"192", "octet2"=>"168", "octet3"=>"1", "octet4"=>"1"}

result = Philiprehberger::RegexLib.extract(:semantic_version, "1.2.3-alpha")
# => {"major"=>"1", "minor"=>"2", "patch"=>"3", "prerelease"=>"alpha", "buildmetadata"=>nil}

result = Philiprehberger::RegexLib.extract(:iban, "GB29NWBK60161331926819")
# => {"country"=>"GB", "check"=>"29", "bban"=>"NWBK60161331926819"}

result = Philiprehberger::RegexLib.extract(:markdown_link, "[Google](https://google.com)")
# => {"text"=>"Google", "url"=>"https://google.com"}

# Patterns without named groups return the full match string
result = Philiprehberger::RegexLib.extract(:slug, "hello-world")
# => "hello-world"
```

### Extracting All Matches

```ruby
text = "Contact hello@example.com or support@test.org"
Philiprehberger::RegexLib.extract_all(:email, text)
# => ["hello@example.com", "support@test.org"]
```

### Pattern Composition

```ruby
# Combine multiple patterns with alternation
combined = Philiprehberger::RegexLib.combine(:email, :url)
"user@example.com".match?(combined)    # => true
"https://example.com".match?(combined) # => true

# Store combined patterns with a name for later lookup
Philiprehberger::RegexLib.combine(:email, :url, name: :contact)
Philiprehberger::RegexLib.pattern(:contact)  # => the combined Regexp

# Look up any pattern by symbol name
Philiprehberger::RegexLib.pattern(:email)  # => Philiprehberger::RegexLib::EMAIL
```

### Validation with Failure Reasons

```ruby
result = Philiprehberger::RegexLib.validate(:email, "user@example.com")
result.valid?  # => true
result.error   # => nil

result = Philiprehberger::RegexLib.validate(:email, "invalid")
result.valid?  # => false
result.error   # => "email must contain @"

result = Philiprehberger::RegexLib.validate(:ipv4, "256.1.1.1")
result.valid?  # => false
result.error   # => "octet 1 must be between 0 and 255"

result = Philiprehberger::RegexLib.validate(:semantic_version, "01.0.0")
result.valid?  # => false
result.error   # => "version components must be non-negative integers"
```

### Auto-Scan

```ruby
text = "Contact user@example.com or visit https://example.com from 192.168.1.1"
results = Philiprehberger::RegexLib.scan(text)
# => [
#   {type: :email, value: "user@example.com", position: 8..24},
#   {type: :url, value: "https://example.com", position: 34..53},
#   {type: :ipv4, value: "192.168.1.1", position: 59..70},
#   ...
# ]

# Useful for PII detection
text = "SSN: 123-45-6789, Phone: +14155552671"
Philiprehberger::RegexLib.scan(text).select { |r| [:ssn, :credit_card].include?(r[:type]) }
```

### Available Patterns

| Constant | Description |
|----------|-------------|
| `EMAIL` | Email address with named captures (local, domain) |
| `URL` | HTTP/HTTPS URL with named captures (scheme, host, port, path, query, fragment) |
| `IPV4` | IPv4 address with named captures (octet1, octet2, octet3, octet4) |
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
| `SEMANTIC_VERSION` | SemVer with named captures (major, minor, patch, prerelease, buildmetadata) |
| `SLUG` | URL slug (lowercase alphanumeric and hyphens) |
| `IBAN` | International Bank Account Number with named captures (country, check, bban) |
| `DOMAIN` | Valid domain name (labels separated by dots, TLD 2+ chars) |
| `FILE_PATH_UNIX` | Unix file path (/foo/bar/baz.txt) |
| `FILE_PATH_WINDOWS` | Windows file path (C:\foo\bar\baz.txt) |
| `JWT` | JSON Web Token (3 base64url segments) |
| `BASE64` | Base64 encoded string |
| `MARKDOWN_LINK` | Markdown link with named captures (text, url) |
| `HASHTAG` | Social media hashtag (#word) |
| `MENTION` | Social media mention (@username) |
| `JSON_STRING` | Double-quoted JSON string with escape support |
| `HTML_TAG` | HTML opening/closing tag |
| `CRON_EXPRESSION` | Cron expression (minute hour day month weekday) |
| `CIDR` | CIDR notation (IPv4/prefix length) |

## API

| Method | Description |
|--------|-------------|
| `RegexLib.match?(pattern_name, string)` | Test string against a named pattern, returns `true`/`false` |
| `RegexLib.extract(pattern_name, string)` | Extract named captures as a `Hash`, full match as `String`, or `nil` |
| `RegexLib.extract_all(pattern_name, string)` | Find all matches in the string, returns `Array<String>` |
| `RegexLib.combine(*pattern_names, name: nil)` | Combine patterns with alternation, optionally store with a name |
| `RegexLib.pattern(name)` | Look up any pattern (built-in or custom) by symbol name |
| `RegexLib.validate(pattern_name, string)` | Validate with specific failure reasons, returns `Result` |
| `RegexLib.scan(string)` | Auto-detect all pattern matches in text, returns `Array<Hash>` |
| `RegexLib.replace(pattern_name, string, replacement)` | Replace first match of a pattern |
| `RegexLib.replace_all(pattern_name, string, replacement)` | Replace all matches of a pattern |
| `RegexLib.mask(pattern_name, string, char:, keep:)` | Mask matches, keeping last N chars visible |
| `RegexLib.highlight(pattern_name, string, before:, after:)` | Wrap matches with delimiter strings |

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

## Support

If you find this project useful:

⭐ [Star the repo](https://github.com/philiprehberger/rb-regex-lib)

🐛 [Report issues](https://github.com/philiprehberger/rb-regex-lib/issues?q=is%3Aissue+is%3Aopen+label%3Abug)

💡 [Suggest features](https://github.com/philiprehberger/rb-regex-lib/issues?q=is%3Aissue+is%3Aopen+label%3Aenhancement)

❤️ [Sponsor development](https://github.com/sponsors/philiprehberger)

🌐 [All Open Source Projects](https://philiprehberger.com/open-source-packages)

💻 [GitHub Profile](https://github.com/philiprehberger)

🔗 [LinkedIn Profile](https://www.linkedin.com/in/philiprehberger)

## License

[MIT](LICENSE)
