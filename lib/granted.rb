# require 'granted/railtie' if defined?(Rails)
require 'granted/version.rb'
require 'granted/grant_class_factory.rb'
require 'granted/granter.rb'
require 'granted/models/grant.rb'
require 'granted/modules/for_granted.rb'
require 'granted/modules/grantee.rb'

module Granted
end

Grant = Granted::Grant
