require 'curb'
require 'json'
require 'gnip-rule/rule'

module GnipRule
  class Client

    attr_reader :url, :username, :password

    def initialize(url, username, password)
      @url = url.gsub(/\.xml$/, '.json')
      @username = username
      @password = password
    end

    def add(value, tag=nil)
      post(@url, jsonify_rules(value, tag))
    end

    def delete(value, tag=nil)
      post("#{@url}?_method=delete", jsonify_rules(value, tag))
    end

    def list()
      rules = nil
      Curl::Easy.http_get(@url) do |curl|
        curl.http_auth_types = :basic
        curl.username = @username
        curl.password = @password
        curl.on_body do |obj|
          rules = JSON.parse(obj)['rules'].collect { |o| Rule.new(o['value'], o['tag']) }
          obj.size
        end
      end
      rules
    end

    def jsonify_rules(values, tag=nil)
      rules = nil
      if values.instance_of?(Array)
        rules = values.collect { |o| o.instance_of?(Rule) ? o : Rule.new(o, tag) }
      elsif values.instance_of?(Rule)
        rules = [values]
      else
        rules = [Rule.new(values, tag)]
      end
      {:rules => rules.collect(&:as_hash)}.to_json
    end

    protected
    def post(url, data)
      Curl::Easy.http_post(url, data) do |curl|
        curl.http_auth_types = :basic
        curl.username = @username
        curl.password = @password
        curl.on_complete do |res|
          if res.response_code >= 400
            raise "Got #{res.response_code}; body: #{res.body_str}"
          end
        end
      end
    end
  end
end
