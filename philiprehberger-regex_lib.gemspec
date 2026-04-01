# frozen_string_literal: true

require_relative 'lib/philiprehberger/regex_lib/version'

Gem::Specification.new do |spec|
  spec.name = 'philiprehberger-regex_lib'
  spec.version = Philiprehberger::RegexLib::VERSION
  spec.authors = ['Philip Rehberger']
  spec.email = ['me@philiprehberger.com']

  spec.summary = 'Pre-built regex patterns for emails, URLs, IPs, dates, and more'
  spec.description = 'A library of tested, documented regex patterns for common data formats. ' \
                     'Includes named captures, validation helpers, and extraction methods.'
  spec.homepage = 'https://philiprehberger.com/open-source-packages/ruby/philiprehberger-regex_lib'
  spec.license = 'MIT'

  spec.required_ruby_version = '>= 3.1.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/philiprehberger/rb-regex-lib'
  spec.metadata['changelog_uri'] = 'https://github.com/philiprehberger/rb-regex-lib/blob/main/CHANGELOG.md'
  spec.metadata['bug_tracker_uri'] = 'https://github.com/philiprehberger/rb-regex-lib/issues'
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.files = Dir['lib/**/*.rb', 'LICENSE', 'README.md', 'CHANGELOG.md']
  spec.require_paths = ['lib']
end
