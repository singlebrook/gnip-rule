require 'bundler'
Bundler.setup

require 'rspec'
require 'webmock/rspec'

WebMock.disable_net_connect!
