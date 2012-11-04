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

    def add(input, tag=nil)
      post(@url, gen_json_payload(input, tag))
    end

    def delete(input, tag=nil)
      post("#@url?_method=delete", gen_json_payload(input, tag))
    end

    def list()
      response = RestClient::Request.new(:method => :get, :url => @url,
                                         :user => @username, :password => @password,
                                         :headers => { :accept => :json }).execute
      JSON.parse(response.to_s)['rules'].collect { |o| Rule.new(o['value'], o['tag']) }
    end

    def gen_json_payload(input, tag=nil)
      input = [input] unless input.respond_to? :collect
      {:rules => input.collect { |i|
        raise 'Input must be convertable to GnipRule::Rule' unless i.respond_to? :to_rule
        i.to_rule(tag).to_hash
      }}.to_json
    end

    protected
    def post(url, data)
      RestClient::Request.new(:method => :post, :url => url, :payload => data,
          :user => @username, :password => @password, :headers => { :content_type => :json, :accept => :json }).execute
    end
  end
end
