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

  s.add_development_dependency 'rspec', '~> 2.10.0'
  s.add_development_dependency 'guard', '~> 1.4.0'
  s.add_development_dependency 'guard-rspec', '~> 1.2.0'
  s.add_development_dependency 'fuubar', '~> 1.1.0'

  if RUBY_PLATFORM[/darwin/]
    s.add_development_dependency 'rb-fsevent'
    s.add_development_dependency 'ruby_gntp'
  elsif RUBY_PLATFORM[/linux/]
    s.add_development_dependency 'rb-inotify'
    s.add_development_dependency 'libnotify'
  elsif RUBY_PLATFORM[/ming/]
    s.add_development_dependency 'wdm'
    s.add_development_dependency 'rb-notifu'
  end

  s.add_dependency 'curb', '>= 0.8.0', '< 0.9.0'
  s.add_dependency 'json', '>= 1.7.0', '< 1.8.0'
end