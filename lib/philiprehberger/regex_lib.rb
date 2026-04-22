# frozen_string_literal: true

require_relative 'regex_lib/version'
require_relative 'regex_lib/patterns'

module Philiprehberger
  module RegexLib
    class Error < StandardError; end

    # Result object returned by validate
    class Result
      attr_reader :error

      def initialize(valid:, error: nil)
        @valid = valid
        @error = error
      end

      def valid?
        @valid
      end
    end

    # Storage for custom combined patterns
    @custom_patterns = {}

    # Test whether a string matches a named pattern.
    #
    # @param pattern_name [Symbol] the pattern name (e.g. :email, :url, :ipv4)
    # @param string [String] the string to test
    # @return [Boolean] true if the string matches the pattern
    # @raise [Error] if the pattern name is not recognized
    def self.match?(pattern_name, string)
      pattern = resolve_pattern!(pattern_name)
      pattern.match?(string)
    end

    # Extract named captures from a string using a named pattern.
    #
    # @param pattern_name [Symbol] the pattern name (e.g. :date_iso, :semantic_version)
    # @param string [String] the string to extract from
    # @return [Hash{String => String}, String, nil] hash of named captures, full match, or nil
    # @raise [Error] if the pattern name is not recognized
    def self.extract(pattern_name, string)
      pattern = resolve_pattern!(pattern_name)
      match = pattern.match(string)
      return nil unless match

      named = match.named_captures
      if named.empty?
        match[0]
      else
        named
      end
    end

    # Find all matches of a named pattern in a string.
    #
    # @param pattern_name [Symbol] the pattern name (e.g. :email, :url)
    # @param string [String] the string to search
    # @return [Array<String>] all matches found in the string
    # @raise [Error] if the pattern name is not recognized
    def self.extract_all(pattern_name, string)
      pattern = resolve_pattern!(pattern_name)
      string.scan(unanchored_pattern(pattern))
    end

    # Count non-overlapping matches of a named pattern in a string.
    #
    # Equivalent to `extract_all(pattern_name, string).length` but avoids
    # allocating the intermediate array of match strings.
    #
    # @param pattern_name [Symbol] the pattern name (e.g. :email, :url)
    # @param string [String] the string to search
    # @return [Integer] number of non-overlapping matches
    # @raise [Error] if the pattern name is not recognized
    def self.count(pattern_name, string)
      pattern = resolve_pattern!(pattern_name)
      string.scan(unanchored_pattern(pattern)).length
    end

    # Combine multiple patterns with alternation.
    #
    # @param pattern_names [Array<Symbol>] the pattern names to combine
    # @param name [Symbol, nil] optional name to store the combined pattern
    # @return [Regexp] the combined pattern
    # @raise [Error] if any pattern name is not recognized
    def self.combine(*pattern_names, name: nil)
      patterns = pattern_names.map { |pn| resolve_pattern!(pn) }
      sources = patterns.map { |p| "(?:#{p.source.delete_prefix('\A').delete_suffix('\z')})" }
      combined = Regexp.new("\\A(?:#{sources.join('|')})\\z")

      if name
        @custom_patterns[name] = combined
      end

      combined
    end

    # Look up a pattern by symbol name.
    #
    # @param name [Symbol] the pattern name
    # @return [Regexp] the pattern
    # @raise [Error] if the pattern name is not recognized
    def self.pattern(name)
      PATTERNS.fetch(name) { @custom_patterns.fetch(name) { raise Error, "Unknown pattern: #{name.inspect}" } }
    end

    # List all built-in pattern names.
    #
    # Returns the symbol names of every pattern available via
    # {.pattern}, sorted ascending. A fresh array is returned on each
    # call so callers may mutate it freely without affecting the
    # underlying pattern registry.
    #
    # @return [Array<Symbol>] sorted list of built-in pattern names
    def self.pattern_names
      PATTERNS.keys.sort
    end

    # Validate a string against a named pattern with specific failure reasons.
    #
    # @param pattern_name [Symbol] the pattern name
    # @param string [String] the string to validate
    # @return [Result] result with valid? and error
    # @raise [Error] if the pattern name is not recognized
    def self.validate(pattern_name, string)
      resolve_pattern!(pattern_name) # ensure pattern exists

      case pattern_name
      when :email
        validate_email(string)
      when :url
        validate_url(string)
      when :ipv4
        validate_ipv4(string)
      when :semantic_version
        validate_semantic_version(string)
      else
        generic_validate(pattern_name, string)
      end
    end

    # Scan a string and return all recognized pattern matches.
    #
    # @param string [String] the string to scan
    # @return [Array<Hash>] array of hashes with :type, :value, :position
    def self.scan(string)
      results = []

      PATTERNS.each do |name, pattern|
        source = pattern.source.delete_prefix('\A').delete_suffix('\z')
        source = source.gsub(/\(\?<[^>]+>/, '(?:')
        unanchored = Regexp.new(source, pattern.options)
        string.scan(unanchored) do
          match = Regexp.last_match
          results << {
            type: name,
            value: match[0],
            position: match.begin(0)..match.end(0)
          }
        end
      end

      results.sort_by { |r| r[:position].begin }
    end

    # Replace the first match of a named pattern in a string.
    #
    # @param pattern_name [Symbol] the pattern name
    # @param string [String] the string to search
    # @param replacement [String] the replacement text
    # @return [String] the string with the first match replaced
    # @raise [Error] if the pattern name is not recognized
    def self.replace(pattern_name, string, replacement)
      pat = unanchored_pattern(resolve_pattern!(pattern_name))
      string.sub(pat, replacement)
    end

    # Replace all matches of a named pattern in a string.
    #
    # @param pattern_name [Symbol] the pattern name
    # @param string [String] the string to search
    # @param replacement [String] the replacement text
    # @return [String] the string with all matches replaced
    # @raise [Error] if the pattern name is not recognized
    def self.replace_all(pattern_name, string, replacement)
      pat = unanchored_pattern(resolve_pattern!(pattern_name))
      string.gsub(pat, replacement)
    end

    # Split a string on matches of a named pattern.
    #
    # Uses the unanchored form of the pattern so matches anywhere in the string act
    # as delimiters. Empty trailing fields are dropped (default Ruby split behavior).
    #
    # @param pattern_name [Symbol] the pattern name
    # @param string [String] the string to split
    # @return [Array<String>] the split segments
    # @raise [Error] if the pattern name is not recognized
    def self.split(pattern_name, string)
      pat = unanchored_pattern(resolve_pattern!(pattern_name))
      string.split(pat)
    end

    # Mask matches of a named pattern, keeping the last N characters visible.
    #
    # @param pattern_name [Symbol] the pattern name
    # @param string [String] the string to search
    # @param char [String] the masking character (default: '*')
    # @param keep [Integer] number of trailing characters to keep visible (default: 4)
    # @return [String] the string with matches masked
    # @raise [Error] if the pattern name is not recognized
    def self.mask(pattern_name, string, char: '*', keep: 4)
      pat = unanchored_pattern(resolve_pattern!(pattern_name))
      string.gsub(pat) do |match|
        if match.length <= keep
          char * match.length
        else
          (char * (match.length - keep)) + match[-keep..]
        end
      end
    end

    # Wrap matches of a named pattern with delimiter strings.
    #
    # @param pattern_name [Symbol] the pattern name
    # @param string [String] the string to search
    # @param before [String] text to insert before each match (default: '**')
    # @param after [String] text to insert after each match (default: '**')
    # @return [String] the string with matches wrapped
    # @raise [Error] if the pattern name is not recognized
    def self.highlight(pattern_name, string, before: '**', after: '**')
      pat = unanchored_pattern(resolve_pattern!(pattern_name))
      string.gsub(pat) { |match| "#{before}#{match}#{after}" }
    end

    # Reset custom patterns (useful for testing)
    # @api private
    def self.reset_custom_patterns!
      @custom_patterns = {}
    end

    # @api private
    def self.resolve_pattern!(name)
      PATTERNS.fetch(name) do
        @custom_patterns.fetch(name) do
          raise Error, "Unknown pattern: #{name.inspect}. Valid patterns: #{PATTERNS.keys.join(', ')}"
        end
      end
    end

    # @api private
    def self.unanchored_pattern(pattern)
      source = pattern.source.delete_prefix('\A').delete_suffix('\z')
      source = source.gsub(/\(\?<[^>]+>/, '(?:')
      Regexp.new(source, pattern.options)
    end

    private_class_method :resolve_pattern!, :unanchored_pattern

    # @api private
    def self.validate_email(string)
      return Result.new(valid: false, error: 'email must not be empty') if string.empty?

      parts = string.split('@', 2)
      return Result.new(valid: false, error: 'email must contain @') unless parts.length == 2

      local, domain = parts
      return Result.new(valid: false, error: 'local part must not exceed 64 characters') if local.length > 64
      return Result.new(valid: false, error: 'domain must contain at least one dot') unless domain.include?('.')
      return Result.new(valid: false, error: 'domain must have a valid TLD') unless domain.match?(/\.[a-zA-Z]{2,}\z/)
      return Result.new(valid: false, error: 'email does not match expected format') unless EMAIL.match?(string)

      Result.new(valid: true)
    end

    # @api private
    def self.validate_url(string)
      return Result.new(valid: false, error: 'URL must not be empty') if string.empty?
      return Result.new(valid: false, error: 'URL must start with http:// or https://') unless string.match?(%r{\Ahttps?://})

      after_scheme = string.sub(%r{\Ahttps?://}, '')
      return Result.new(valid: false, error: 'URL must contain a host') if after_scheme.empty? || after_scheme.start_with?('/')
      return Result.new(valid: false, error: 'URL does not match expected format') unless URL.match?(string)

      Result.new(valid: true)
    end

    # @api private
    def self.validate_ipv4(string)
      return Result.new(valid: false, error: 'IPv4 must not be empty') if string.empty?

      octets = string.split('.')
      return Result.new(valid: false, error: 'IPv4 must have exactly 4 octets') unless octets.length == 4

      octets.each_with_index do |octet, i|
        return Result.new(valid: false, error: "octet #{i + 1} must be numeric") unless octet.match?(/\A\d+\z/)

        val = octet.to_i
        return Result.new(valid: false, error: "octet #{i + 1} must be between 0 and 255") unless val.between?(0, 255)
      end

      return Result.new(valid: false, error: 'IPv4 does not match expected format') unless IPV4.match?(string)

      Result.new(valid: true)
    end

    # @api private
    def self.validate_semantic_version(string)
      return Result.new(valid: false, error: 'version must not be empty') if string.empty?

      # Strip pre-release and build metadata for core version check
      core = string.split('-', 2).first.split('+', 2).first
      parts = core.split('.')
      return Result.new(valid: false, error: 'version must have major.minor.patch') unless parts.length == 3

      parts.each do |part|
        return Result.new(valid: false, error: 'version components must be non-negative integers') unless part.match?(/\A(?:0|[1-9]\d*)\z/)
      end

      return Result.new(valid: false, error: 'version does not match expected format') unless SEMANTIC_VERSION.match?(string)

      Result.new(valid: true)
    end

    # @api private
    def self.generic_validate(pattern_name, string)
      pattern = resolve_pattern!(pattern_name)
      if pattern.match?(string)
        Result.new(valid: true)
      else
        Result.new(valid: false, error: "string does not match #{pattern_name} pattern")
      end
    end

    private_class_method :validate_email, :validate_url, :validate_ipv4,
                         :validate_semantic_version, :generic_validate
  end
end
