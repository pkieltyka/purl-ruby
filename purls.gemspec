# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'purls/version'

Gem::Specification.new do |s|
  s.name        = 'purls'
  s.version     = Purls::VERSION
  s.platform    = Gem::Platform::RUBY
  s.summary     = '...'
  s.description = s.summary

  s.authors     = ['Peter Kieltyka']
  s.email       = ['peter@pressly.com']
  s.homepage    = 'https://github.com/pkieltyka/purls-ruby'
  
  s.required_rubygems_version = ">= 1.3.6"
  
  s.files        = Dir['README.md', 'lib/**/*']
  s.require_path = 'lib'

  s.add_dependency('msgpack', ['~> 0.5.8'])       if RUBY_ENGINE == 'ruby'  
  s.add_dependency('msgpack-jruby', ['~> 1.4.0']) if RUBY_ENGINE == 'jruby'

  # s.add_development_dependency 'rake-compiler'
  s.add_development_dependency 'rake'
end
