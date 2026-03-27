# Changelog

All notable changes to this gem will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.0] - 2026-03-26

### Added
- Initial release
- 15 pre-built regex patterns: EMAIL, URL, IPV4, IPV6, UUID, PHONE_E164, DATE_ISO, TIME_ISO, DATETIME_ISO, HEX_COLOR, CREDIT_CARD, SSN, MAC_ADDRESS, SEMANTIC_VERSION, SLUG
- Named captures for DATE_ISO and SEMANTIC_VERSION patterns
- `RegexLib.match?` helper for testing strings against named patterns
- `RegexLib.extract` helper for extracting named captures
- `RegexLib.extract_all` helper for finding all matches in a string
