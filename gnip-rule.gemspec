# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'gnip-rule/version'

Gem::Specification.new do |s|
  s.name        = 'gnip-rule'
  s.version     = GnipRule::VERSION

  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Eric Wendelin', 'Leon Miller-Out']
  s.email       = ['me@eriwen.com', 'leon@singlebrook.com']
  s.homepage    = 'https://github.com/singlebrook/gnip-rule'
  s.summary     = %q{Ruby library for working with the Gnip Rules API}
  s.description = s.summary

  s.rubyforge_project = 'gnip-rule'

  s.files = Dir['lib/**/*']
  s.require_paths = ['lib']

  s.required_ruby_version = '>= 2.0'

  s.add_development_dependency 'rake', '~> 11.3'
  s.add_development_dependency 'rspec', '~> 3.5'
  s.add_development_dependency 'webmock', '~> 2.0'
  s.add_development_dependency 'fuubar', '~> 2.2'
  s.add_development_dependency 'coveralls', '~> 0.6'

  s.add_dependency 'rest-client', '~> 1.6'
  s.add_dependency 'json', '~> 1.8'
  s.add_dependency 'jruby-openssl' if RUBY_PLATFORM == 'java'
end
