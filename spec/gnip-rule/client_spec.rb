require 'spec-helper'

require 'gnip-rule/client'

describe GnipRule::Client do
  let(:fake_curb) { double("Curl::Easy") }
  before do
    Curl::Easy.stub(:http_post => fake_curb)
    Curl::Easy.stub(:http_get => fake_curb)
  end

  subject { GnipRule::Client.new('https://api.gnip.com:443/accounts/foo/publishers/twitter/streams/track/prod/rules.json', 'username', 'password') }

  describe '#initialize' do
    it 'should convert XML URLs to JSON' do
      subject.url.should == 'https://api.gnip.com:443/accounts/foo/publishers/twitter/streams/track/prod/rules.json'
    end
  end

  describe '#add' do
    it 'should POST rule to the given URL with given credentials' do
      Curl::Easy.should_receive(:http_post)
      subject.add('value', 'tag')
    end

    xit 'should raise an error if we got a 4xx or 5xx HTTP status'
  end

  describe '#delete' do
    it 'should POST rule json to a URL with given credentials' do
      Curl::Easy.should_receive(:http_post)
      subject.delete('value', 'tag')
    end
  end

  describe '#list' do
    it 'should GET a URL with given credentials' do
      Curl::Easy.should_receive(:http_get)
      subject.list()
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
