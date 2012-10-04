require 'spec-helper'

require 'gnip-rule/client'

describe GnipRule::Client do
  let(:base_url) { 'https://api.gnip.com:443/accounts/foo/publishers/twitter/streams/track/prod/rules.json' }
  let(:base_url_with_auth) { 'https://username:password@api.gnip.com:443/accounts/foo/publishers/twitter/streams/track/prod/rules.json' }
  subject { GnipRule::Client.new(base_url, 'username', 'password') }

  describe '#initialize' do
    it 'should convert XML URLs to JSON' do
      subject.url.should == base_url
    end
  end

  describe '#add' do
    it 'should POST rule to the given URL with given credentials' do
      stub_request(:post, base_url_with_auth).
          with(:body => '{"rules":[{"value":"value","tag":"tag"}]}').
          to_return(:status => 200, :body => '', :headers => {})
      subject.add('value', 'tag')
    end

    it 'should raise an error if Gnip returns HTTP error' do
      stub_request(:post, base_url_with_auth).
          with(:body => '{"rules":[{"value":"value","tag":"tag"}]}').
          to_return(:status => 401, :body => 'Error message', :headers => {})
      lambda { subject.add('value', 'tag') }.should raise_error('Got 401; body: Error message')
    end
  end

  describe '#delete' do
    it 'should POST rule json to a URL with given credentials' do
      stub_request(:post, "#{base_url_with_auth}?_method=delete").
          with(:body => '{"rules":[{"value":"value","tag":"tag"}]}').
          to_return(:status => 200, :body => '', :headers => {})
      subject.delete('value', 'tag')
    end
  end

  describe '#list' do
    it 'should GET a URL with given credentials' do
      stub_request(:get, base_url_with_auth).
          to_return(:status => 200, :body => '{"rules":[{"value":"foo","tag":"baz"},{"value":"bar","tag":"baz"}]}')
      rules = subject.list()
      rules.size.should == 2
      rules.map { |r| r.valid?.should == true }
    end
  end

  describe '#jsonify_rules' do
    it 'should JSONify Strings' do
      json = subject.jsonify_rules('foo', 'bar')
      json.should == '{"rules":[{"value":"foo","tag":"bar"}]}'
    end

    it 'should JSONify Rules' do
      json = subject.jsonify_rules(GnipRule::Rule.new('baz', 'foo'))
      json.should == '{"rules":[{"value":"baz","tag":"foo"}]}'
    end

    it 'should JSONify an Array of Strings with a tag' do
      json = subject.jsonify_rules(['foo', 'bar'], 'baz')
      json.should == '{"rules":[{"value":"foo","tag":"baz"},{"value":"bar","tag":"baz"}]}'
    end

    it 'should JSONify an Array of Rules' do
      rule1 = GnipRule::Rule.new('baz', 'foo')
      rule2 = GnipRule::Rule.new('bar', 'thing')
      json = subject.jsonify_rules([rule1, rule2])
      json.should == '{"rules":[{"value":"baz","tag":"foo"},{"value":"bar","tag":"thing"}]}'
    end
  end
end
