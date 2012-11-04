require 'spec-helper'

require 'gnip-rule/rule'

describe GnipRule::Rule do
  describe '#initialize' do
    it 'should allow an optional tag' do
      rule = GnipRule::Rule.new('value')
      rule.tag.should be_nil

      rule_with_tag = GnipRule::Rule.new('value', 'tag')
      rule_with_tag.tag.should == 'tag'
    end
  end

  describe '#valid?' do
    it 'should consider rules with "stop words" to be invalid' do
      GnipRule::Rule.new('an value').should_not be_valid
    end
    it 'should consider rules that are too long to be invalid' do
      rule = GnipRule::Rule.new('01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789')
      rule.should_not be_valid
    end
    it 'should consider empty sources to be invalid' do
      GnipRule::Rule.new('foo source: bar').should_not be_valid
    end
    it 'should consider negative ORs to be invalid' do
      GnipRule::Rule.new('-iphone OR ipad').should_not be_valid
    end
    it 'should consider rules with more than 10 positive terms invalid' do
      GnipRule::Rule.new('one two three four five six seven eight nine ten eleven').should_not be_valid
    end
    it 'should consider stop words within quotes to be valid' do
      GnipRule::Rule.new('"foo the bar" baz').should be_valid
    end
    it 'should consider rules without "stop words" to be valid' do
      GnipRule::Rule.new('value').should be_valid
    end
  end

  describe '#to_json' do
    it 'should omit tag if tag not defined' do
      rule = GnipRule::Rule.new('foo')
      rule.to_json.should == '{"value":"foo"}'
    end
    it 'should add tag if defined' do
      rule = GnipRule::Rule.new('foo', 'bar')
      rule.to_json.should == '{"value":"foo","tag":"bar"}'
    end
  end

  describe '#to_rule' do
    it 'should return itself' do
      rule = GnipRule::Rule.new('foo', 'bar')
      rule.to_rule.should == rule
    end
  end
end
