# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require 'id_service/version'

Gem::Specification.new do |s|
  s.name        = "id_service"
  s.version     = IdService::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['James Thompson']
  s.email       = ['jamest@thereadyproject.com']
  s.homepage    = "http://github.com/readyproject/id_service"
  s.summary     = "A client and server for sequential & unique id generation"
  s.description = "IdService provides a client and server for setting up a sequential & unique id generation service."

  s.required_rubygems_version = ">= 1.3.6"

  s.add_dependency 'thrift'
  s.add_dependency 'activesupport'

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'shoulda-matchers'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'timecop'

  s.files        = Dir.glob('{bin,lib}/**/*') + %w(LICENSE README.md)
  s.executables  = ['id_server']
  s.require_path = 'lib'
end
