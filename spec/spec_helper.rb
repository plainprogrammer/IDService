require 'rubygems'
require 'bundler/setup'

$:.unshift File.dirname(File.join('../../lib', __FILE__))

require 'capybara/dsl'
require 'timecop'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.

RSpec.configure do |config|
  config.order = 'random'

  config.include(Capybara::DSL)
end
