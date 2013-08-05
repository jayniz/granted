require 'rubygems'
require 'simplecov'
SimpleCov.start
require 'bundler'
Bundler.require

RSpec.configure do |config|
  config.mock_with :rspec
end

require File.expand_path("../../lib/la_claire", __FILE__)
