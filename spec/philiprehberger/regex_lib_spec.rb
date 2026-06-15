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

  describe 'IBAN' do
    subject(:pattern) { described_class::IBAN }

    it 'matches valid IBANs' do
      %w[GB29NWBK60161331926819 DE89370400440532013000 FR7630006000011234567890189].each do |iban|
        expect(iban).to match(pattern), "expected #{iban} to match"
      end
    end

    it 'rejects invalid IBANs' do
      ['', 'gb29NWBK60161331926819', '1234567890', 'XX', 'AB12'].each do |str|
        expect(str).not_to match(pattern), "expected #{str.inspect} not to match"
      end
    end

    it 'captures country, check, bban' do
      match = pattern.match('GB29NWBK60161331926819')
      expect(match[:country]).to eq('GB')
      expect(match[:check]).to eq('29')
      expect(match[:bban]).to eq('NWBK60161331926819')
    end
  end

  describe 'DOMAIN' do
    subject(:pattern) { described_class::DOMAIN }

    it 'matches valid domains' do
      %w[example.com sub.domain.co.uk my-site.org a.io].each do |domain|
        expect(domain).to match(pattern), "expected #{domain} to match"
      end
    end

    it 'rejects invalid domains' do
      ['', 'localhost', '-example.com', 'example-.com', '.com', 'example.c'].each do |str|
        expect(str).not_to match(pattern), "expected #{str.inspect} not to match"
      end
    end
  end

  describe 'FILE_PATH_UNIX' do
    subject(:pattern) { described_class::FILE_PATH_UNIX }

    it 'matches valid Unix paths' do
      %w[/home /home/user /home/user/file.txt /var/log/syslog /tmp/a/b/c].each do |path|
        expect(path).to match(pattern), "expected #{path} to match"
      end
    end

    it 'rejects invalid Unix paths' do
      ['', 'home/user', 'C:\\Users', 'relative/path'].each do |str|
        expect(str).not_to match(pattern), "expected #{str.inspect} not to match"
      end
    end
  end

  describe 'FILE_PATH_WINDOWS' do
    subject(:pattern) { described_class::FILE_PATH_WINDOWS }

    it 'matches valid Windows paths' do
      ['C:\\Users', 'D:\\folder\\file.txt', 'C:\\Program Files\\app.exe'].each do |path|
        expect(path).to match(pattern), "expected #{path} to match"
      end
    end

    it 'rejects invalid Windows paths' do
      ['', '/home/user', 'C:', '\\Users\\file.txt'].each do |str|
        expect(str).not_to match(pattern), "expected #{str.inspect} not to match"
      end
    end
  end

  describe 'JWT' do
    subject(:pattern) { described_class::JWT }

    it 'matches valid JWTs' do
      [
        'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxMjM0NTY3ODkwIn0.dozjgNryP4J3jVmNHl0w5N_XgL0n3I9PlFUP0THsR8U',
        'abc.def.ghi',
        'a-b_c.d-e_f.g-h_i'
      ].each do |jwt|
        expect(jwt).to match(pattern), "expected #{jwt} to match"
      end
    end

    it 'rejects invalid JWTs' do
      ['', 'abc.def', 'abc', 'abc.def.ghi.jkl', 'abc def.ghi.jkl'].each do |str|
        expect(str).not_to match(pattern), "expected #{str.inspect} not to match"
      end
    end
  end

  describe 'BASE64' do
    subject(:pattern) { described_class::BASE64 }

    it 'matches valid base64 strings' do
      ['', 'SGVsbG8=', 'SGVsbG8gV29ybGQ=', 'dGVzdA==', 'YWJj'].each do |b64|
        expect(b64).to match(pattern), "expected #{b64.inspect} to match"
      end
    end

    it 'rejects invalid base64 strings' do
      ['SGVsbG8', 'abc!', 'a', 'ab', 'abc'].each do |str|
        expect(str).not_to match(pattern), "expected #{str.inspect} not to match"
      end
    end
  end

  describe 'MARKDOWN_LINK' do
    subject(:pattern) { described_class::MARKDOWN_LINK }

    it 'matches valid markdown links' do
      [
        '[Google](https://google.com)',
        '[My Link](http://example.com/path)',
        '[text with spaces](https://example.com)'
      ].each do |link|
        expect(link).to match(pattern), "expected #{link} to match"
      end
    end

    it 'rejects invalid markdown links' do
      ['', '[](url)', '[text]()', '[text]url', 'text(url)', '[]()'].each do |str|
        expect(str).not_to match(pattern), "expected #{str.inspect} not to match"
      end
    end

    it 'captures text and url' do
      match = pattern.match('[Google](https://google.com)')
      expect(match[:text]).to eq('Google')
      expect(match[:url]).to eq('https://google.com')
    end
  end

  describe 'HASHTAG' do
    subject(:pattern) { described_class::HASHTAG }

    it 'matches valid hashtags' do
      %w[#hello #Ruby #CamelCase #test123 #a].each do |tag|
        expect(tag).to match(pattern), "expected #{tag} to match"
      end
    end

    it 'rejects invalid hashtags' do
      ['', '#', '#123', '# space', 'noHash', '#-dash'].each do |str|
        expect(str).not_to match(pattern), "expected #{str.inspect} not to match"
      end
    end
  end

  describe 'MENTION' do
    subject(:pattern) { described_class::MENTION }

    it 'matches valid mentions' do
      %w[@user @JohnDoe @test123 @a].each do |mention|
        expect(mention).to match(pattern), "expected #{mention} to match"
      end
    end

    it 'rejects invalid mentions' do
      ['', '@', '@123', '@ space', 'noAt', '@-dash'].each do |str|
        expect(str).not_to match(pattern), "expected #{str.inspect} not to match"
      end
    end
  end

  describe 'JSON_STRING' do
    subject(:pattern) { described_class::JSON_STRING }

    it 'matches valid JSON strings' do
      ['"hello"', '"hello world"', '"escaped \\"quote\\""', '"line\\nbreak"', '""'].each do |str|
        expect(str).to match(pattern), "expected #{str.inspect} to match"
      end
    end

    it 'rejects invalid JSON strings' do
      ['', "'single'", 'noQuotes', '"unclosed', '"bad"quote"'].each do |str|
        expect(str).not_to match(pattern), "expected #{str.inspect} not to match"
      end
    end
  end

  describe 'HTML_TAG' do
    subject(:pattern) { described_class::HTML_TAG }

    it 'matches valid HTML tags' do
      ['<div>', '</div>', '<br/>', '<img src="test.png">', '<a href="url" class="link">',
       "<input type='text'>"].each do |tag|
        expect(tag).to match(pattern), "expected #{tag.inspect} to match"
      end
    end

    it 'rejects invalid HTML tags' do
      ['', '<>', '< div>', '<123>'].each do |str|
        expect(str).not_to match(pattern), "expected #{str.inspect} not to match"
      end
    end
  end

  describe 'CRON_EXPRESSION' do
    subject(:pattern) { described_class::CRON_EXPRESSION }

    it 'matches valid cron expressions' do
      ['0 12 * * 1', '*/5 * * * *', '30 2 15 6 *'].each do |cron|
        expect(cron).to match(pattern), "expected #{cron.inspect} to match"
      end
    end

    it 'rejects invalid cron expressions' do
      ['60 * * * *', 'abc'].each do |str|
        expect(str).not_to match(pattern), "expected #{str.inspect} not to match"
      end
    end
  end

  describe 'CIDR' do
    subject(:pattern) { described_class::CIDR }

    it 'matches valid CIDR notations' do
      %w[192.168.1.0/24 10.0.0.0/8 172.16.0.0/16].each do |cidr|
        expect(cidr).to match(pattern), "expected #{cidr} to match"
      end
    end

    it 'rejects invalid CIDR notations' do
      %w[192.168.1.0 192.168.1.0/33 abc/24].each do |str|
        expect(str).not_to match(pattern), "expected #{str.inspect} not to match"
      end
    end
  end

  describe '.replace' do
    it 'replaces the first match of a pattern' do
      text = '123-45-6789 and 987-65-4321'
      result = described_class.replace(:ssn, text, '[REDACTED]')
      expect(result).to eq('[REDACTED] and 987-65-4321')
    end

    it 'raises Error for unknown patterns' do
      expect { described_class.replace(:unknown, 'test', 'x') }.to raise_error(Philiprehberger::RegexLib::Error)
    end
  end

  describe '.replace_all' do
    it 'replaces all matches of a pattern' do
      text = '123-45-6789 and 987-65-4321'
      result = described_class.replace_all(:ssn, text, '[REDACTED]')
      expect(result).to eq('[REDACTED] and [REDACTED]')
    end

    it 'raises Error for unknown patterns' do
      expect { described_class.replace_all(:unknown, 'test', 'x') }.to raise_error(Philiprehberger::RegexLib::Error)
    end
  end

  describe '.split' do
    it 'splits text on email occurrences' do
      text = 'start hello@example.com middle support@test.org end'
      result = described_class.split(:email, text)
      expect(result).to eq(['start ', ' middle ', ' end'])
    end

    it 'splits text on url occurrences' do
      text = 'before https://example.com after https://test.org done'
      result = described_class.split(:url, text)
      expect(result).to eq(['before ', ' after ', ' done'])
    end

    it 'returns a single-element array when no match is found' do
      expect(described_class.split(:email, 'no emails here')).to eq(['no emails here'])
    end

    it 'raises Error for unknown patterns' do
      expect { described_class.split(:unknown, 'test') }.to raise_error(Philiprehberger::RegexLib::Error)
    end
  end

  describe '.mask' do
    it 'masks matches with asterisks keeping last N chars' do
      text = 'SSN: 123-45-6789'
      result = described_class.mask(:ssn, text, char: '*', keep: 4)
      expect(result).to eq('SSN: *******6789')
    end

    it 'fully masks when match length is less than or equal to keep' do
      text = '#hi'
      result = described_class.mask(:hashtag, text, char: '*', keep: 4)
      expect(result).to eq('***')
    end

    it 'raises Error for unknown patterns' do
      expect { described_class.mask(:unknown, 'test') }.to raise_error(Philiprehberger::RegexLib::Error)
    end
  end

  describe '.highlight' do
    it 'wraps matches with default delimiters' do
      text = 'Visit https://example.com today'
      result = described_class.highlight(:url, text)
      expect(result).to eq('Visit **https://example.com** today')
    end

    it 'wraps matches with custom delimiters' do
      text = 'Call +14155552671 now'
      result = described_class.highlight(:phone_e164, text, before: '[', after: ']')
      expect(result).to eq('Call [+14155552671] now')
    end

    it 'raises Error for unknown patterns' do
      expect { described_class.highlight(:unknown, 'test') }.to raise_error(Philiprehberger::RegexLib::Error)
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

  describe '.any_match?' do
    it 'returns true when at least one string matches' do
      expect(described_class.any_match?(:email, 'not-an-email', 'foo@bar.com')).to be(true)
    end

    it 'returns false when no string matches' do
      expect(described_class.any_match?(:email, 'nope', 'still-nope')).to be(false)
    end

    it 'returns false when no strings are given' do
      expect(described_class.any_match?(:email)).to be(false)
    end

    it 'raises Error for an unknown pattern name' do
      expect { described_class.any_match?(:nonexistent, 'whatever') }.to raise_error(described_class::Error)
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

    it 'extracts named captures from EMAIL' do
      result = described_class.extract(:email, 'user@example.com')
      expect(result).to eq('local' => 'user', 'domain' => 'example.com')
    end

    it 'extracts named captures from URL' do
      result = described_class.extract(:url, 'https://example.com:8080/path?q=1#frag')
      expect(result).to include(
        'scheme' => 'https',
        'host' => 'example.com',
        'port' => '8080',
        'path' => '/path',
        'query' => 'q=1',
        'fragment' => 'frag'
      )
    end

    it 'extracts named captures from URL without optional parts' do
      result = described_class.extract(:url, 'https://example.com')
      expect(result).to include('scheme' => 'https', 'host' => 'example.com')
      expect(result['port']).to be_nil
      expect(result['query']).to be_nil
      expect(result['fragment']).to be_nil
    end

    it 'extracts named captures from IPV4' do
      result = described_class.extract(:ipv4, '192.168.1.1')
      expect(result).to eq(
        'octet1' => '192',
        'octet2' => '168',
        'octet3' => '1',
        'octet4' => '1'
      )
    end

    it 'extracts named captures from IBAN' do
      result = described_class.extract(:iban, 'GB29NWBK60161331926819')
      expect(result).to eq(
        'country' => 'GB',
        'check' => '29',
        'bban' => 'NWBK60161331926819'
      )
    end

    it 'extracts named captures from MARKDOWN_LINK' do
      result = described_class.extract(:markdown_link, '[Google](https://google.com)')
      expect(result).to eq('text' => 'Google', 'url' => 'https://google.com')
    end

    it 'returns full match string for patterns without named captures' do
      expect(described_class.extract(:slug, 'hello-world')).to eq('hello-world')
    end

    it 'returns nil for no match' do
      expect(described_class.extract(:date_iso, 'not-a-date')).to be_nil
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

  describe '.count' do
    it 'returns 0 when there are no matches' do
      expect(described_class.count(:email, 'no emails here')).to eq(0)
    end

    it 'returns 1 for a single match' do
      expect(described_class.count(:email, 'contact user@example.com today')).to eq(1)
    end

    it 'returns the count of multiple matches for :email' do
      expect(described_class.count(:email, 'a@b.com x c@d.org')).to eq(2)
    end

    it 'matches the length of extract_all for the same input' do
      text = 'Contact hello@example.com or support@test.org or ops@x.io'
      expect(described_class.count(:email, text)).to eq(described_class.extract_all(:email, text).length)
    end

    it 'raises Error for unknown patterns' do
      expect { described_class.count(:unknown, 'test') }.to raise_error(Philiprehberger::RegexLib::Error)
    end
  end

  describe '.combine' do
    after { described_class.reset_custom_patterns! }

    it 'combines multiple patterns with alternation' do
      combined = described_class.combine(:email, :ipv4)
      expect('user@example.com').to match(combined)
      expect('192.168.1.1').to match(combined)
      expect('not-a-match').not_to match(combined)
    end

    it 'stores named combined patterns' do
      described_class.combine(:email, :url, name: :contact)
      pattern = described_class.pattern(:contact)
      expect('user@example.com').to match(pattern)
      expect('https://example.com').to match(pattern)
    end

    it 'raises Error for unknown pattern names' do
      expect do
        described_class.combine(:email, :nonexistent)
      end.to raise_error(Philiprehberger::RegexLib::Error, /Unknown pattern/)
    end
  end

  describe '.pattern_names' do
    it 'returns an Array of Symbols' do
      names = described_class.pattern_names
      expect(names).to be_an(Array)
      expect(names).to all(be_a(Symbol))
    end

    it 'returns names sorted ascending' do
      names = described_class.pattern_names
      expect(names).to eq(names.sort)
    end

    it 'includes known built-in pattern names' do
      names = described_class.pattern_names
      expect(names).to include(:email, :url, :uuid, :slug, :semantic_version, :jwt, :cidr, :cron_expression)
    end

    it 'returns a fresh array each call so mutation does not persist' do
      first = described_class.pattern_names
      first << :mutated_name
      second = described_class.pattern_names
      expect(second).not_to include(:mutated_name)
    end
  end

  describe '.pattern' do
    after { described_class.reset_custom_patterns! }

    it 'looks up built-in patterns by name' do
      expect(described_class.pattern(:email)).to eq(described_class::EMAIL)
      expect(described_class.pattern(:url)).to eq(described_class::URL)
    end

    it 'looks up custom combined patterns' do
      described_class.combine(:email, :url, name: :contact)
      expect(described_class.pattern(:contact)).to be_a(Regexp)
    end

    it 'raises Error for unknown patterns' do
      expect do
        described_class.pattern(:nonexistent)
      end.to raise_error(Philiprehberger::RegexLib::Error, /Unknown pattern/)
    end
  end

  describe '.validate' do
    describe 'email validation' do
      it 'returns valid for correct emails' do
        result = described_class.validate(:email, 'user@example.com')
        expect(result).to be_valid
        expect(result.error).to be_nil
      end

      it 'returns error for empty string' do
        result = described_class.validate(:email, '')
        expect(result).not_to be_valid
        expect(result.error).to eq('email must not be empty')
      end

      it 'returns error for missing @' do
        result = described_class.validate(:email, 'userexample.com')
        expect(result).not_to be_valid
        expect(result.error).to eq('email must contain @')
      end

      it 'returns error for overly long local part' do
        long_local = 'a' * 65
        result = described_class.validate(:email, "#{long_local}@example.com")
        expect(result).not_to be_valid
        expect(result.error).to eq('local part must not exceed 64 characters')
      end

      it 'returns error for domain without dot' do
        result = described_class.validate(:email, 'user@localhost')
        expect(result).not_to be_valid
        expect(result.error).to eq('domain must contain at least one dot')
      end

      it 'returns error for domain without valid TLD' do
        result = described_class.validate(:email, 'user@example.c')
        expect(result).not_to be_valid
        expect(result.error).to eq('domain must have a valid TLD')
      end
    end

    describe 'URL validation' do
      it 'returns valid for correct URLs' do
        result = described_class.validate(:url, 'https://example.com')
        expect(result).to be_valid
      end

      it 'returns error for empty string' do
        result = described_class.validate(:url, '')
        expect(result).not_to be_valid
        expect(result.error).to eq('URL must not be empty')
      end

      it 'returns error for missing scheme' do
        result = described_class.validate(:url, 'example.com')
        expect(result).not_to be_valid
        expect(result.error).to eq('URL must start with http:// or https://')
      end

      it 'returns error for missing host' do
        result = described_class.validate(:url, 'http://')
        expect(result).not_to be_valid
        expect(result.error).to eq('URL must contain a host')
      end
    end

    describe 'IPv4 validation' do
      it 'returns valid for correct IPv4' do
        result = described_class.validate(:ipv4, '192.168.1.1')
        expect(result).to be_valid
      end

      it 'returns error for empty string' do
        result = described_class.validate(:ipv4, '')
        expect(result).not_to be_valid
        expect(result.error).to eq('IPv4 must not be empty')
      end

      it 'returns error for wrong number of octets' do
        result = described_class.validate(:ipv4, '192.168.1')
        expect(result).not_to be_valid
        expect(result.error).to eq('IPv4 must have exactly 4 octets')
      end

      it 'returns error for non-numeric octets' do
        result = described_class.validate(:ipv4, 'abc.def.ghi.jkl')
        expect(result).not_to be_valid
        expect(result.error).to eq('octet 1 must be numeric')
      end

      it 'returns error for out-of-range octets' do
        result = described_class.validate(:ipv4, '256.1.1.1')
        expect(result).not_to be_valid
        expect(result.error).to eq('octet 1 must be between 0 and 255')
      end
    end

    describe 'semantic version validation' do
      it 'returns valid for correct versions' do
        result = described_class.validate(:semantic_version, '1.2.3')
        expect(result).to be_valid
      end

      it 'returns error for empty string' do
        result = described_class.validate(:semantic_version, '')
        expect(result).not_to be_valid
        expect(result.error).to eq('version must not be empty')
      end

      it 'returns error for missing patch' do
        result = described_class.validate(:semantic_version, '1.2')
        expect(result).not_to be_valid
        expect(result.error).to eq('version must have major.minor.patch')
      end

      it 'returns error for leading zeros' do
        result = described_class.validate(:semantic_version, '01.0.0')
        expect(result).not_to be_valid
        expect(result.error).to eq('version components must be non-negative integers')
      end
    end

    describe 'generic validation' do
      it 'returns valid for matching patterns' do
        result = described_class.validate(:slug, 'hello-world')
        expect(result).to be_valid
      end

      it 'returns error for non-matching patterns' do
        result = described_class.validate(:slug, 'Hello World')
        expect(result).not_to be_valid
        expect(result.error).to eq('string does not match slug pattern')
      end
    end

    it 'raises Error for unknown patterns' do
      expect do
        described_class.validate(:unknown, 'test')
      end.to raise_error(Philiprehberger::RegexLib::Error, /Unknown pattern/)
    end
  end

  describe '.scan' do
    it 'detects multiple pattern types in text' do
      text = 'Contact user@example.com or visit https://example.com from 192.168.1.1'
      results = described_class.scan(text)

      types = results.map { |r| r[:type] }
      expect(types).to include(:email)
      expect(types).to include(:url)
      expect(types).to include(:ipv4)
    end

    it 'returns value and position for each match' do
      text = 'Email: user@example.com'
      results = described_class.scan(text)

      email_result = results.find { |r| r[:type] == :email }
      expect(email_result).not_to be_nil
      expect(email_result[:value]).to eq('user@example.com')
      expect(email_result[:position]).to be_a(Range)
    end

    it 'returns empty array for text with no matches' do
      results = described_class.scan('just plain text')
      # Some patterns like slug/base64 may match plain words, so filter for specific types
      specific = results.select { |r| %i[email url ipv4 ipv6 uuid ssn credit_card].include?(r[:type]) }
      expect(specific).to eq([])
    end

    it 'detects SSNs for PII scanning' do
      text = 'SSN is 123-45-6789 and phone is +14155552671'
      results = described_class.scan(text)

      ssn_result = results.find { |r| r[:type] == :ssn }
      expect(ssn_result).not_to be_nil
      expect(ssn_result[:value]).to eq('123-45-6789')

      phone_result = results.find { |r| r[:type] == :phone_e164 }
      expect(phone_result).not_to be_nil
      expect(phone_result[:value]).to eq('+14155552671')
    end

    it 'returns results sorted by position' do
      text = '192.168.1.1 user@example.com'
      results = described_class.scan(text)
      positions = results.map { |r| r[:position].begin }
      expect(positions).to eq(positions.sort)
    end

    it 'detects hashtags and mentions' do
      text = 'Follow @user and check #trending'
      results = described_class.scan(text)

      mention = results.find { |r| r[:type] == :mention }
      expect(mention).not_to be_nil
      expect(mention[:value]).to eq('@user')

      hashtag = results.find { |r| r[:type] == :hashtag }
      expect(hashtag).not_to be_nil
      expect(hashtag[:value]).to eq('#trending')
    end
  end
end
