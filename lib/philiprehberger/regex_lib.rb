# frozen_string_literal: true

require_relative 'regex_lib/version'
require_relative 'regex_lib/patterns'

module Philiprehberger
  module RegexLib
    class Error < StandardError; end

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
    # @return [Hash{String => String}, nil] hash of named captures, or nil if no match
    # @raise [Error] if the pattern name is not recognized
    def self.extract(pattern_name, string)
      pattern = resolve_pattern!(pattern_name)
      match = pattern.match(string)
      return nil unless match

      named = match.named_captures
      named.empty? ? nil : named
    end

    # Find all matches of a named pattern in a string.
    #
    # @param pattern_name [Symbol] the pattern name (e.g. :email, :url)
    # @param string [String] the string to search
    # @return [Array<String>] all matches found in the string
    # @raise [Error] if the pattern name is not recognized
    def self.extract_all(pattern_name, string)
      pattern = resolve_pattern!(pattern_name)
      # Remove anchors for scanning
      unanchored = Regexp.new(pattern.source.delete_prefix('\A').delete_suffix('\z'), pattern.options)
      string.scan(unanchored)
    end

    # @api private
    def self.resolve_pattern!(name)
      PATTERNS.fetch(name) do
        raise Error, "Unknown pattern: #{name.inspect}. Valid patterns: #{PATTERNS.keys.join(', ')}"
      end
    end

    private_class_method :resolve_pattern!
  end
end
