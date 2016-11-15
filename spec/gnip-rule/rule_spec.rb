require 'spec-helper'

require 'gnip-rule/rule'

RSpec.describe GnipRule::Rule do
  describe '#initialize' do
    it 'should allow an optional tag' do
      rule = GnipRule::Rule.new('value')
      expect(rule.tag).to be_nil

      rule_with_tag = GnipRule::Rule.new('value', 'tag')
      expect(rule_with_tag.tag).to eq('tag')
    end
  end

  describe '#valid?' do
    it 'should consider rules with "stop words" to be invalid' do
      expect(GnipRule::Rule.new('an value')).to_not be_valid
    end
    it 'should consider rules that are too long to be invalid' do
      rule = GnipRule::Rule.new('x' * 2050)
      expect(rule).to_not be_valid
    end
    it 'should consider empty sources to be invalid' do
      expect(GnipRule::Rule.new('foo source: bar')).to_not be_valid
    end
    it 'should consider negative ORs to be invalid' do
      expect(GnipRule::Rule.new('-iphone OR ipad')).to_not be_valid
      expect(GnipRule::Rule.new('apple OR -lang:en')).to_not be_valid
    end
    it 'should consider rules with more than 30 positive terms invalid' do
      expect(GnipRule::Rule.new('one two three four five six seven eight nine ten 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30')).to be_valid
      expect(GnipRule::Rule.new('one two three four five six seven eight nine ten 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31')).to_not be_valid
    end
    it 'should consider stop words within quotes to be valid' do
      expect(GnipRule::Rule.new('"foo the bar" baz')).to be_valid
    end
    it 'should consider rules without "stop words" to be valid' do
      expect(GnipRule::Rule.new('value')).to be_valid
    end
  end

  describe '#to_s' do
    it 'should return json output' do
      rule = GnipRule::Rule.new('foo')
      expect(rule.to_s).to eq('{"value":"foo"}')
    end
  end

  describe '#to_json' do
    it 'should omit tag if tag not defined' do
      rule = GnipRule::Rule.new('foo')
      expect(rule.to_json).to eq('{"value":"foo"}')
    end
    it 'should add tag if defined' do
      rule = GnipRule::Rule.new('foo', 'bar')
      expect(rule.to_json).to eq('{"value":"foo","tag":"bar"}')
    end
  end

  describe '#to_rule' do
    it 'should return itself' do
      rule = GnipRule::Rule.new('foo', 'bar')
      expect(rule.to_rule).to eq(rule)
    end
  end
end
