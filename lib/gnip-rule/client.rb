require 'curb'
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
      Curl::Easy.http_get(@url) do |curl|
        curl.http_auth_types = :basic
        curl.username = @username
        curl.password = @password
        curl.on_body do |obj|
          return obj
        end
      end
    end

    def jsonify_rules(values, tag=nil)
      json = nil
      if values.instance_of?(Array)
        rules_json = values.collect { |value|
          value.instance_of?(Rule) ? value.to_json : GnipRule::Rule.new(value, tag).to_json
        }.join(',')
        json = "{\"rules\":[#{rules_json}]}"
      elsif values.instance_of?(Rule)
        json = "{\"rules\":[#{values.to_json}]}"
      else
        json = "{\"rules\":[#{Rule.new(values, tag).to_json}]}"
      end
      json
    end

    protected
    def post(url, data)
      Curl::Easy.http_post(url, data) do |curl|
        curl.http_auth_types = :basic
        curl.username = @username
        curl.password = @password
        curl.on_complete do |res|
          if res.response_code >= 400
            # TODO: get message in resp body
            raise 'Invalid request'
          end
        end
      end
    end
  end
end
