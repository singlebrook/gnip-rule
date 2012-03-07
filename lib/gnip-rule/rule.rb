module GnipRule
  class Rule
    attr_accessor :value, :tag

    def initialize(value, tag=nil)
      @value = value
      @tag = tag
    end

    def valid?
      # See http://docs.gnip.com/w/page/35663947/Power%20Track
      if contains_stop_word?(@value)
        return false
      end
      true
    end

    def to_json
      tag_json = @tag ? ",\"tag\":\"#{@tag}\"" : ''
      "{\"value\":\"#{@value}\"#{tag_json}}"
    end

    def to_s
      to_json
    end

    protected
    def contains_stop_word?(value)
      stop_words = %W(a an and at but by com from http https if in is it its me my or rt the this to too via we www you)
      (stop_words & value.split(/\s/)).size > 0
    end
  end
end
