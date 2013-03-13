# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'gnip-rule/version'

Gem::Specification.new do |s|
  s.name        = 'gnip-rule'
  s.version     = GnipRule::VERSION

  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Eric Wendelin']
  s.email       = ['me@eriwen.com']
  s.homepage    = 'https://github.com/eriwen/gnip-rule'
  s.summary     = %q{Ruby library for working with the Gnip Rules API}
  s.description = s.summary

  s.rubyforge_project = 'gnip-rule'

  s.files = Dir['lib/**/*']
  s.require_paths = ['lib']

  s.add_development_dependency 'rake', '~> 10.0.3'
  s.add_development_dependency 'rspec', '~> 2.13.0'
  s.add_development_dependency 'webmock', '~> 1.8.11'
  s.add_development_dependency 'guard', '~> 1.6.2'
  s.add_development_dependency 'guard-rspec', '~> 2.5.0'
  s.add_development_dependency 'fuubar', '~> 1.1.0'

  if RbConfig::CONFIG['host_os'] =~ /darwin/
    s.add_development_dependency 'rb-fsevent'
    s.add_development_dependency 'ruby_gntp'
  elsif RbConfig::CONFIG['host_os'] =~ /linux/
    s.add_development_dependency 'rb-inotify'
    s.add_development_dependency 'libnotify'
  elsif RbConfig::CONFIG['host_os'] =~ /msmin|mingw/
    s.add_development_dependency 'wdm'
    s.add_development_dependency 'rb-notifu'
  end

  s.add_dependency 'rest-client', '~> 1.6.7'
  s.add_dependency 'json', '~> 1.7.7'
  s.add_dependency 'jruby-openssl' if RUBY_PLATFORM == 'java'
end
