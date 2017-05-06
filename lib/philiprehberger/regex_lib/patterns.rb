# frozen_string_literal: true

module Philiprehberger
  module RegexLib
    # Email address (local@domain.tld) with named captures
    EMAIL = %r{\A(?<local>[a-zA-Z0-9.!\#$%&'*+/=?^_`{|}~-]+)@(?<domain>[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\.[a-zA-Z]{2,})\z}

    # HTTP/HTTPS URL with named captures
    URL = %r{\A(?<scheme>https?)://(?<host>[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*)(?::(?<port>\d{1,5}))?(?<path>/[^\s?#]*)?(?:\?(?<query>[^\s#]*))?(?:#(?<fragment>\S*))?\z}

    # IPv4 address (0-255 per octet) with named captures
    IPV4 = /\A(?<octet1>25[0-5]|2[0-4]\d|[01]?\d\d?)\.(?<octet2>25[0-5]|2[0-4]\d|[01]?\d\d?)\.(?<octet3>25[0-5]|2[0-4]\d|[01]?\d\d?)\.(?<octet4>25[0-5]|2[0-4]\d|[01]?\d\d?)\z/

    # IPv6 address (simplified: full, compressed, and loopback forms)
    IPV6 = /\A(?:(?:[0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}|(?:[0-9a-fA-F]{1,4}:){1,7}:|(?:[0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|(?:[0-9a-fA-F]{1,4}:){1,5}(?::[0-9a-fA-F]{1,4}){1,2}|(?:[0-9a-fA-F]{1,4}:){1,4}(?::[0-9a-fA-F]{1,4}){1,3}|(?:[0-9a-fA-F]{1,4}:){1,3}(?::[0-9a-fA-F]{1,4}){1,4}|(?:[0-9a-fA-F]{1,4}:){1,2}(?::[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:(?::[0-9a-fA-F]{1,4}){1,6}|:(?::[0-9a-fA-F]{1,4}){1,7}|::)\z/

    # UUID v4 (8-4-4-4-12 hex format)
    UUID = /\A[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}\z/

    # E.164 phone number (+1234567890, 7-15 digits after +)
    PHONE_E164 = /\A\+[1-9]\d{6,14}\z/

    # ISO 8601 date (YYYY-MM-DD) with named captures
    DATE_ISO = /\A(?<year>\d{4})-(?<month>0[1-9]|1[0-2])-(?<day>0[1-9]|[12]\d|3[01])\z/

    # ISO 8601 time (HH:MM:SS with optional timezone)
    TIME_ISO = /\A(?:[01]\d|2[0-3]):[0-5]\d:[0-5]\d(?:Z|[+-](?:[01]\d|2[0-3]):[0-5]\d)?\z/

    # ISO 8601 datetime (YYYY-MM-DDTHH:MM:SS with optional timezone)
    DATETIME_ISO = /\A\d{4}-(?:0[1-9]|1[0-2])-(?:0[1-9]|[12]\d|3[01])T(?:[01]\d|2[0-3]):[0-5]\d:[0-5]\d(?:Z|[+-](?:[01]\d|2[0-3]):[0-5]\d)?\z/

    # Hex color (#RGB or #RRGGBB)
    HEX_COLOR = /\A#(?:[0-9a-fA-F]{3}|[0-9a-fA-F]{6})\z/

    # Credit card number (13-19 digits, optional spaces or dashes)
    CREDIT_CARD = /\A\d[ -]?\d{3,4}[ -]?\d{3,4}[ -]?\d{3,4}[ -]?\d{0,4}\z/

    # US Social Security Number (XXX-XX-XXXX)
    SSN = /\A\d{3}-\d{2}-\d{4}\z/

    # MAC address (AA:BB:CC:DD:EE:FF or AA-BB-CC-DD-EE-FF)
    MAC_ADDRESS = /\A[0-9a-fA-F]{2}(?:[-:][0-9a-fA-F]{2}){5}\z/

    # Semantic version (major.minor.patch with optional pre-release and build metadata)
    SEMANTIC_VERSION = /\A(?<major>0|[1-9]\d*)\.(?<minor>0|[1-9]\d*)\.(?<patch>0|[1-9]\d*)(?:-(?<prerelease>[0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?(?:\+(?<buildmetadata>[0-9a-zA-Z-]+(?:\.[0-9a-zA-Z-]+)*))?\z/

    # URL slug (lowercase alphanumeric and hyphens)
    SLUG = /\A[a-z0-9]+(?:-[a-z0-9]+)*\z/

    # International Bank Account Number with named captures
    IBAN = /\A(?<country>[A-Z]{2})(?<check>\d{2})(?<bban>[A-Z0-9]{1,30})\z/

    # Valid domain name (labels separated by dots, TLD 2+ chars)
    DOMAIN = /\A[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*\.[a-zA-Z]{2,}\z/

    # Unix file path (/foo/bar/baz.txt)
    FILE_PATH_UNIX = %r{\A/(?:[^\0/]+/?)*\z}

    # Windows file path (C:\foo\bar\baz.txt)
    FILE_PATH_WINDOWS = Regexp.new('\A[a-zA-Z]:\\\\(?:[^\x00\\\\/:*?"<>|]+\\\\)*[^\x00\\\\/:*?"<>|]*\z')

    # JSON Web Token (3 base64url segments separated by dots)
    JWT = /\A[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+\z/

    # Base64 encoded string (full match)
    BASE64 = %r{\A(?:[A-Za-z0-9+/]{4})*(?:[A-Za-z0-9+/]{2}==|[A-Za-z0-9+/]{3}=)?\z}

    # Markdown link format [text](url) with named captures
    MARKDOWN_LINK = /\A\[(?<text>[^\]]+)\]\((?<url>[^)]+)\)\z/

    # Social media hashtag (#word)
    HASHTAG = /\A#[a-zA-Z]\w*\z/

    # Social media mention (@username)
    MENTION = /\A@[a-zA-Z]\w*\z/

    # Double-quoted JSON string with escape support
    JSON_STRING = /\A"(?:[^"\\]|\\.)*"\z/

    # HTML opening/closing tag
    HTML_TAG = %r{\A</?[a-zA-Z][a-zA-Z0-9]*(?:\s+[a-zA-Z][a-zA-Z0-9-]*(?:\s*=\s*(?:"[^"]*"|'[^']*'|[^\s>]+))?)*\s*/?>}

    # Map of pattern names to constants for helper methods
    PATTERNS = {
      email: EMAIL,
      url: URL,
      ipv4: IPV4,
      ipv6: IPV6,
      uuid: UUID,
      phone_e164: PHONE_E164,
      date_iso: DATE_ISO,
      time_iso: TIME_ISO,
      datetime_iso: DATETIME_ISO,
      hex_color: HEX_COLOR,
      credit_card: CREDIT_CARD,
      ssn: SSN,
      mac_address: MAC_ADDRESS,
      semantic_version: SEMANTIC_VERSION,
      slug: SLUG,
      iban: IBAN,
      domain: DOMAIN,
      file_path_unix: FILE_PATH_UNIX,
      file_path_windows: FILE_PATH_WINDOWS,
      jwt: JWT,
      base64: BASE64,
      markdown_link: MARKDOWN_LINK,
      hashtag: HASHTAG,
      mention: MENTION,
      json_string: JSON_STRING,
      html_tag: HTML_TAG
    }.freeze
  end
end
