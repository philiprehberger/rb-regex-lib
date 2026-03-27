# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Philiprehberger::RegexLib do
  it 'has a version number' do
    expect(Philiprehberger::RegexLib::VERSION).not_to be_nil
  end

  describe 'EMAIL' do
    subject(:pattern) { described_class::EMAIL }

    it 'matches valid emails' do
      %w[user@example.com first.last@domain.co.uk user+tag@sub.domain.com].each do |email|
        expect(email).to match(pattern), "expected #{email} to match"
      end
    end

    it 'rejects invalid emails' do
      ['', 'plaintext', '@domain.com', 'user@', 'user@.com', 'user @domain.com'].each do |str|
        expect(str).not_to match(pattern), "expected #{str.inspect} not to match"
      end
    end
  end

  describe 'URL' do
    subject(:pattern) { described_class::URL }

    it 'matches valid URLs' do
      %w[
        http://example.com
        https://example.com
        https://sub.domain.com/path
        https://example.com:8080/path?q=1
        https://example.com/path#anchor
      ].each do |url|
        expect(url).to match(pattern), "expected #{url} to match"
      end
    end

    it 'rejects invalid URLs' do
      ['', 'ftp://example.com', 'example.com', '://example.com', 'http://'].each do |str|
        expect(str).not_to match(pattern), "expected #{str.inspect} not to match"
      end
    end
  end

  describe 'IPV4' do
    subject(:pattern) { described_class::IPV4 }

    it 'matches valid IPv4 addresses' do
      %w[0.0.0.0 192.168.1.1 255.255.255.255 10.0.0.1 127.0.0.1].each do |ip|
        expect(ip).to match(pattern), "expected #{ip} to match"
      end
    end

    it 'rejects invalid IPv4 addresses' do
      ['', '256.1.1.1', '1.1.1', '1.1.1.1.1', '192.168.1.999', 'abc.def.ghi.jkl'].each do |str|
        expect(str).not_to match(pattern), "expected #{str.inspect} not to match"
      end
    end
  end

  describe 'IPV6' do
    subject(:pattern) { described_class::IPV6 }

    it 'matches valid IPv6 addresses' do
      %w[
        2001:0db8:85a3:0000:0000:8a2e:0370:7334
        ::1
        ::
        fe80::1
        2001:db8::1
      ].each do |ip|
        expect(ip).to match(pattern), "expected #{ip} to match"
      end
    end

    it 'rejects invalid IPv6 addresses' do
      ['', '12345::1', '2001:db8:85a3:0000:0000:8a2e:0370:7334:extra'].each do |str|
        expect(str).not_to match(pattern), "expected #{str.inspect} not to match"
      end
    end
  end

  describe 'UUID' do
    subject(:pattern) { described_class::UUID }

    it 'matches valid UUIDs' do
      %w[
        550e8400-e29b-41d4-a716-446655440000
        123e4567-e89b-12d3-a456-426614174000
        00000000-0000-0000-0000-000000000000
      ].each do |uuid|
        expect(uuid).to match(pattern), "expected #{uuid} to match"
      end
    end

    it 'rejects invalid UUIDs' do
      ['', '550e8400e29b41d4a716446655440000', '550e8400-e29b-41d4-a716',
       'zzzzzzzz-zzzz-zzzz-zzzz-zzzzzzzzzzzz'].each do |str|
        expect(str).not_to match(pattern), "expected #{str.inspect} not to match"
      end
    end
  end

  describe 'PHONE_E164' do
    subject(:pattern) { described_class::PHONE_E164 }

    it 'matches valid E.164 phone numbers' do
      %w[+14155552671 +442071234567 +861012345678].each do |phone|
        expect(phone).to match(pattern), "expected #{phone} to match"
      end
    end

    it 'rejects invalid phone numbers' do
      ['', '14155552671', '+0123456', '+1', '+123456789012345678'].each do |str|
        expect(str).not_to match(pattern), "expected #{str.inspect} not to match"
      end
    end
  end

  describe 'DATE_ISO' do
    subject(:pattern) { described_class::DATE_ISO }

    it 'matches valid ISO dates' do
      %w[2026-03-26 2000-01-01 1999-12-31].each do |date|
        expect(date).to match(pattern), "expected #{date} to match"
      end
    end

    it 'rejects invalid dates' do
      ['', '2026/03/26', '2026-13-01', '2026-00-01', '2026-03-32', '26-03-26'].each do |str|
        expect(str).not_to match(pattern), "expected #{str.inspect} not to match"
      end
    end

    it 'captures year, month, day' do
      match = pattern.match('2026-03-26')
      expect(match[:year]).to eq('2026')
      expect(match[:month]).to eq('03')
      expect(match[:day]).to eq('26')
    end
  end

  describe 'TIME_ISO' do
    subject(:pattern) { described_class::TIME_ISO }

    it 'matches valid ISO times' do
      %w[12:30:45 00:00:00 23:59:59 12:30:45Z 12:30:45+05:30 12:30:45-08:00].each do |time|
        expect(time).to match(pattern), "expected #{time} to match"
      end
    end

    it 'rejects invalid times' do
      ['', '24:00:00', '12:60:00', '12:30', '1:30:00'].each do |str|
        expect(str).not_to match(pattern), "expected #{str.inspect} not to match"
      end
    end
  end

  describe 'DATETIME_ISO' do
    subject(:pattern) { described_class::DATETIME_ISO }

    it 'matches valid ISO datetimes' do
      %w[2026-03-26T12:30:45 2026-03-26T12:30:45Z 2026-03-26T12:30:45+05:30].each do |dt|
        expect(dt).to match(pattern), "expected #{dt} to match"
      end
    end

    it 'rejects invalid datetimes' do
      ['', '2026-03-26 12:30:45', '2026-03-26T25:00:00', '2026-13-26T12:30:45'].each do |str|
        expect(str).not_to match(pattern), "expected #{str.inspect} not to match"
      end
    end
  end

  describe 'HEX_COLOR' do
    subject(:pattern) { described_class::HEX_COLOR }

    it 'matches valid hex colors' do
      %w[#fff #FFF #abc #aabbcc #AABBCC #123456].each do |color|
        expect(color).to match(pattern), "expected #{color} to match"
      end
    end

    it 'rejects invalid hex colors' do
      ['', '#ff', '#ffff', '#gggggg', 'aabbcc', '#1234567'].each do |str|
        expect(str).not_to match(pattern), "expected #{str.inspect} not to match"
      end
    end
  end

  describe 'CREDIT_CARD' do
    subject(:pattern) { described_class::CREDIT_CARD }

    it 'matches valid credit card numbers' do
      ['4111111111111111', '4111 1111 1111 1111', '4111-1111-1111-1111', '5500000000000004'].each do |cc|
        expect(cc).to match(pattern), "expected #{cc} to match"
      end
    end

    it 'rejects invalid credit card numbers' do
      ['', '12345', 'abcd1234abcd1234'].each do |str|
        expect(str).not_to match(pattern), "expected #{str.inspect} not to match"
      end
    end
  end

  describe 'SSN' do
    subject(:pattern) { described_class::SSN }

    it 'matches valid SSNs' do
      %w[123-45-6789 000-00-0000 999-99-9999].each do |ssn|
        expect(ssn).to match(pattern), "expected #{ssn} to match"
      end
    end

    it 'rejects invalid SSNs' do
      ['', '123456789', '123-456-789', '12-345-6789'].each do |str|
        expect(str).not_to match(pattern), "expected #{str.inspect} not to match"
      end
    end
  end

  describe 'MAC_ADDRESS' do
    subject(:pattern) { described_class::MAC_ADDRESS }

    it 'matches valid MAC addresses' do
      %w[00:1A:2B:3C:4D:5E aa:bb:cc:dd:ee:ff 00-1A-2B-3C-4D-5E].each do |mac|
        expect(mac).to match(pattern), "expected #{mac} to match"
      end
    end

    it 'rejects invalid MAC addresses' do
      ['', '00:1A:2B:3C:4D', '00:1A:2B:3C:4D:5E:FF', 'GG:HH:II:JJ:KK:LL'].each do |str|
        expect(str).not_to match(pattern), "expected #{str.inspect} not to match"
      end
    end
  end

  describe 'SEMANTIC_VERSION' do
    subject(:pattern) { described_class::SEMANTIC_VERSION }

    it 'matches valid semver strings' do
      %w[0.1.0 1.0.0 1.2.3 1.0.0-alpha 1.0.0-alpha.1 1.0.0+build.123 1.0.0-beta+build.456].each do |ver|
        expect(ver).to match(pattern), "expected #{ver} to match"
      end
    end

    it 'rejects invalid semver strings' do
      ['', '1.0', 'v1.0.0', '1.0.0.0', '01.0.0'].each do |str|
        expect(str).not_to match(pattern), "expected #{str.inspect} not to match"
      end
    end

    it 'captures major, minor, patch, prerelease' do
      match = pattern.match('1.2.3-alpha.1+build.456')
      expect(match[:major]).to eq('1')
      expect(match[:minor]).to eq('2')
      expect(match[:patch]).to eq('3')
      expect(match[:prerelease]).to eq('alpha.1')
      expect(match[:buildmetadata]).to eq('build.456')
    end
  end

  describe 'SLUG' do
    subject(:pattern) { described_class::SLUG }

    it 'matches valid slugs' do
      %w[hello hello-world my-long-slug 123 a1b2c3].each do |slug|
        expect(slug).to match(pattern), "expected #{slug} to match"
      end
    end

    it 'rejects invalid slugs' do
      ['', 'Hello', 'hello_world', '-hello', 'hello-', 'hello--world', 'hello world'].each do |str|
        expect(str).not_to match(pattern), "expected #{str.inspect} not to match"
      end
    end
  end

  describe '.match?' do
    it 'returns true for matching strings' do
      expect(described_class.match?(:email, 'user@example.com')).to be true
    end

    it 'returns false for non-matching strings' do
      expect(described_class.match?(:email, 'not-an-email')).to be false
    end

    it 'raises Error for unknown patterns' do
      expect do
        described_class.match?(:unknown, 'test')
      end.to raise_error(Philiprehberger::RegexLib::Error, /Unknown pattern/)
    end
  end

  describe '.extract' do
    it 'extracts named captures from DATE_ISO' do
      result = described_class.extract(:date_iso, '2026-03-26')
      expect(result).to eq('year' => '2026', 'month' => '03', 'day' => '26')
    end

    it 'extracts named captures from SEMANTIC_VERSION' do
      result = described_class.extract(:semantic_version, '1.2.3-alpha')
      expect(result).to include('major' => '1', 'minor' => '2', 'patch' => '3', 'prerelease' => 'alpha')
    end

    it 'returns nil for no match' do
      expect(described_class.extract(:date_iso, 'not-a-date')).to be_nil
    end

    it 'returns nil for patterns without named captures' do
      expect(described_class.extract(:slug, 'hello-world')).to be_nil
    end

    it 'raises Error for unknown patterns' do
      expect { described_class.extract(:unknown, 'test') }.to raise_error(Philiprehberger::RegexLib::Error)
    end
  end

  describe '.extract_all' do
    it 'finds all matches in a string' do
      text = 'Contact us at hello@example.com or support@test.org'
      results = described_class.extract_all(:email, text)
      expect(results).to contain_exactly('hello@example.com', 'support@test.org')
    end

    it 'returns empty array for no matches' do
      expect(described_class.extract_all(:email, 'no emails here')).to eq([])
    end

    it 'raises Error for unknown patterns' do
      expect { described_class.extract_all(:unknown, 'test') }.to raise_error(Philiprehberger::RegexLib::Error)
    end
  end
end
