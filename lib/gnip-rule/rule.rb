require 'json'

class String
  def to_rule(tag=nil)
    GnipRule::Rule.new(self, tag)
  end
end

module GnipRule
  class Rule
    attr_accessor :value, :tag

    def initialize(value, tag=nil)
      @value = value
      @tag = tag
    end

    def valid?
      return false if too_long?
      return false if too_many_positive_terms?
      return false if contains_stop_word?
      return false if contains_empty_source?
      return false if contains_negated_or?
      return true
    end

    # NOTE: Unused variable for consistency with other to_rule impls
    def to_rule(_=nil)
      self
    end

    def to_json
      to_hash.to_json
    end

    def to_hash
      obj = {:value => @value}
      obj[:tag] = @tag unless @tag.nil?
      obj
    end

    def to_s
      to_json
    end

    protected
    def contains_stop_word?
      stop_words = %W(a an and at but by com from http https if in is it its me my or rt the this to too via we www you)
      (stop_words & @value.gsub(/\"[^\"]*\"/, '').split(/\s/)).size > 0
    end

    def too_long?
      @value.size > 1024
    end

    def contains_negated_or?
      !@value[/\-\w+ OR/].nil? || !@value[/OR \-\w+/].nil?
    end

    def too_many_positive_terms?
      @value.scan(/\b\w+|\"[\-\s\w]+\"\b/).size > 30
    end

    def contains_empty_source?
      !@value[/source\:\s/].nil?
    end
  end
end
