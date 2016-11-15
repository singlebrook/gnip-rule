require 'spec-helper'

require 'gnip-rule/client'

RSpec.describe GnipRule::Client do
  let(:xml_base_url) { 'https://api.gnip.com:443/accounts/foo/publishers/twitter/streams/track/prod/rules.xml' }
  let(:base_url) { 'https://api.gnip.com:443/accounts/foo/publishers/twitter/streams/track/prod/rules.json' }
  let(:basic_auth) { { basic_auth: ['username', 'password'] } }

  describe '.new' do
    it 'should convert XML URLs to JSON' do
      expect(GnipRule::Client.new(xml_base_url, 'username', 'password').url).to eq(base_url)
    end

    it 'should not munch JSON URLs' do
      expect(GnipRule::Client.new(base_url, 'username', 'password').url).to eq(base_url)
    end
  end

  describe 'instance' do
    subject { GnipRule::Client.new(base_url, 'username', 'password') }

    describe '#add' do
      it 'should POST rule to the given URL with given credentials' do
        stub_request(:post, base_url).
            with(basic_auth).
            with(:body => '{"rules":[{"value":"value","tag":"tag"}]}').
            to_return(:status => 200, :body => '', :headers => {})
        subject.add('value', 'tag')
      end

      it 'should raise an error if Gnip returns HTTP error' do
        stub_request(:post, base_url).
            with(basic_auth).
            with(:body => '{"rules":[{"value":"value","tag":"tag"}]}').
            to_return(:status => 401, :body => 'Error message', :headers => {})
        expect { subject.add('value', 'tag') }.to raise_error(RestClient::Unauthorized)
      end
    end

    describe '#delete' do
      it 'should POST rule json to a URL with given credentials' do
        stub_request(:post, "#{base_url}?_method=delete").
            with(basic_auth).
            with(:body => '{"rules":[{"value":"value","tag":"tag"}]}').
            to_return(:status => 200, :body => '', :headers => {})
        subject.delete('value', 'tag')
      end
    end

    describe '#list' do
      it 'should GET a URL with given credentials' do
        stub_request(:get, base_url).
            with(basic_auth).
            to_return(:status => 200, :body => '{"rules":[{"value":"foo","tag":"baz"},{"value":"bar","tag":"baz"}]}')
        rules = subject.list()
        expect(rules.size).to eq(2)
        rules.map { |r| expect(r.valid?).to eq(true) }
      end

      it 'should raise an error if Gnip returns HTTP error' do
        stub_request(:get, base_url).
            with(basic_auth).
            to_return(:status => 401, :body => 'Error message', :headers => {})
        expect { subject.list() }.to raise_error(RestClient::Unauthorized)
      end
    end

    describe '#jsonify_rules' do
      it 'should JSONify Strings' do
        json = subject.gen_json_payload('foo', 'bar')
        expect(json).to eq('{"rules":[{"value":"foo","tag":"bar"}]}')
      end

      it 'should JSONify Rules' do
        json = subject.gen_json_payload(GnipRule::Rule.new('baz', 'foo'))
        expect(json).to eq('{"rules":[{"value":"baz","tag":"foo"}]}')
      end

      it 'should JSONify an Array of Strings with a tag' do
        json = subject.gen_json_payload(['foo', 'bar'], 'baz')
        expect(json).to eq('{"rules":[{"value":"foo","tag":"baz"},{"value":"bar","tag":"baz"}]}')
      end

      it 'should JSONify an Array of Rules' do
        rule1 = GnipRule::Rule.new('baz', 'foo')
        rule2 = GnipRule::Rule.new('bar', 'thing')
        json = subject.gen_json_payload([rule1, rule2])
        expect(json).to eq('{"rules":[{"value":"baz","tag":"foo"},{"value":"bar","tag":"thing"}]}')
      end
    end
  end
end
