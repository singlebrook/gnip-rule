require 'spec-helper'

require 'gnip-rule/rule'

describe GnipRule::Rule do
  describe '#initialize' do
    it 'should allow an optional tag' do
      rule = GnipRule::Rule.new('value')
      rule.tag.should == nil

      rule_with_tag = GnipRule::Rule.new('value', 'tag')
      rule_with_tag.tag.should == 'tag'
    end
  end

  describe '#valid?' do
    it 'should consider rules with "stop words" to be invalid' do
      rule = GnipRule::Rule.new('an value')
      rule.valid?.should == false
    end
    it 'should consider rules without "stop words" to be valid' do
      rule = GnipRule::Rule.new('value')
      rule.valid?.should == true
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
end
