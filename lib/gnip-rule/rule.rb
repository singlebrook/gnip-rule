require 'json'

module GnipRule
  class Rule
    attr_accessor :value, :tag

    def initialize(value, tag=nil)
      @value = value
      @tag = tag
    end

    def valid?
      # See http://docs.gnip.com/w/page/35663947/Power%20Track
      if contains_stop_word?(@value) || too_long?(@value) || contains_negated_or?(@value) || too_many_positive_terms?(@value) || contains_empty_source?(@value)
        return false
      end
      true
    end

    def as_json
      as_hash.to_json
    end

    def as_hash
      obj = {:value => @value}
      obj[:tag] = @tag unless @tag.nil?
      obj
    end

    def to_s
      as_json
    end

    protected
    def contains_stop_word?(value)
      stop_words = %W(a an and at but by com from http https if in is it its me my or rt the this to too via we www you)
      (stop_words & value.gsub(/\"[^\"]*\"/, '').split(/\s/)).size > 0
    end

    def too_long?(value)
      value.size > 1024
    end

    def contains_negated_or?(value)
      !value[/\-\w+ OR/].nil?
    end

    def too_many_positive_terms?(value)
      value.scan(/\b\w+|\"[\-\s\w]+\"\b/).size > 10
    end

    def contains_empty_source?(value)
      !value[/source\:\s/].nil?
    end
  end
end
