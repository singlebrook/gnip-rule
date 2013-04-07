require 'bundler'
Bundler.setup

require 'coveralls'
Coveralls.wear!

require 'rspec'
require 'webmock/rspec'

WebMock.disable_net_connect!
