# encoding: utf-8
require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
Bundler.require

require 'rake'
require 'jeweler'

Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "granted"
  gem.homepage = "http://github.com/jayniz/granted"
  gem.license = "MIT"
  gem.summary = %Q{Grant or revoke access to your ActiveRecord models}
  gem.description = %Q{Takes care of defining what actions one model is allowed to do with another model.}
  gem.email = "jannis@gmail.com"
  gem.authors = ["Jannis Hermanns"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__), 'lib'))
Dir.glob('granted/tasks/*.rake').each { |r| import r }
