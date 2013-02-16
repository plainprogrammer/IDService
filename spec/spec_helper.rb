require 'rubygems'
require 'bundler/setup'

require 'simplecov'
SimpleCov.start do
  add_filter "/spec/"
  add_filter "/bin/"
end

$:.unshift File.dirname(File.join('../../lib', __FILE__))

require 'timecop'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.

RSpec.configure do |config|
  config.order = 'random'
end
