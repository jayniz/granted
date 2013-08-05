# require 'granted/railtie' if defined?(Rails)
require 'granted/models/grant.rb'
require 'granted/modules/for_granted.rb'

module Granted
end

Grant = Granted::Grant
