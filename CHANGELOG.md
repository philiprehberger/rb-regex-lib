# Changelog

All notable changes to this gem will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.7.0] - 2026-06-14

### Added
- `RegexLib.any_match?(pattern_name, *strings)` — true if any of the supplied strings matches the named pattern. Convenience wrapper for the common `any? { |s| match?(name, s) }` pattern in form-validation use cases.

## [0.6.0] - 2026-04-22

### Added
- `RegexLib.split(pattern_name, string)` — split a string on matches of a named pattern.

## [0.5.0] - 2026-04-19

### Added
- `RegexLib.count(name, string)` — non-overlapping match count for the named pattern; avoids the array allocation of `extract_all(...).length`

## [0.4.0] - 2026-04-17

### Added
- `RegexLib.pattern_names` returns a sorted list of all built-in pattern symbol names

## [0.3.1] - 2026-03-31

### Changed
- Standardize README badges, support section, and license format

## [0.3.0] - 2026-03-31

### Added
- `CRON_EXPRESSION` and `CIDR` regex patterns
- `RegexLib.replace(pattern, string, replacement)` for single match replacement
- `RegexLib.replace_all(pattern, string, replacement)` for global replacement
- `RegexLib.mask(pattern, string, char:, keep:)` for redacting sensitive data
- `RegexLib.highlight(pattern, string, before:, after:)` for wrapping matches

### Fixed
- RuboCop line length limit normalized to 140 (was 500)

## [0.2.0] - 2026-03-28

### Added
- 11 new patterns: IBAN, DOMAIN, FILE_PATH_UNIX, FILE_PATH_WINDOWS, JWT, BASE64, MARKDOWN_LINK, HASHTAG, MENTION, JSON_STRING, HTML_TAG
- Named capture group extraction for URL, EMAIL, IPV4, SEMANTIC_VERSION, IBAN, MARKDOWN_LINK
- `RegexLib.combine(*patterns, name:)` for pattern composition
- `RegexLib.pattern(name)` for pattern lookup by symbol
- `RegexLib.validate(pattern, string)` with specific failure reasons
- `RegexLib.scan(string)` for auto-detecting all pattern types in text

## [0.1.1] - 2026-03-26

### Added

- Add GitHub funding configuration

## [0.1.0] - 2026-03-26

### Added
- Initial release
- 15 pre-built regex patterns: EMAIL, URL, IPV4, IPV6, UUID, PHONE_E164, DATE_ISO, TIME_ISO, DATETIME_ISO, HEX_COLOR, CREDIT_CARD, SSN, MAC_ADDRESS, SEMANTIC_VERSION, SLUG
- Named captures for DATE_ISO and SEMANTIC_VERSION patterns
- `RegexLib.match?` helper for testing strings against named patterns
- `RegexLib.extract` helper for extracting named captures
- `RegexLib.extract_all` helper for finding all matches in a string
