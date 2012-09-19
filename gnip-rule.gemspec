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

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_development_dependency 'rspec'

  s.add_dependency 'curb', '>= 0.8.0', '< 0.9.0'
  s.add_dependency 'json', '>= 1.6.0', '< 1.7.0'
end
