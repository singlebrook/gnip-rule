require 'rest-client'
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
      post("#@url?_method=delete", jsonify_rules(value, tag))
    end

    def list()
      response = RestClient::Request.new(:method => :get, :url => @url,
                                         :user => @username, :password => @password,
                                         :headers => { :accept => :json }).execute
      JSON.parse(response.to_s)['rules'].collect { |o| Rule.new(o['value'], o['tag']) }
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
      RestClient::Request.new(:method => :post, :url => url, :payload => data,
          :user => @username, :password => @password, :headers => { :content_type => :json, :accept => :json }).execute
    end
  end
end
