$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "granted/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "granted"
  s.version     = Granted::VERSION
  s.authors     = ["TODO: Your name"]
  s.email       = ["TODO: Your email"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Granted."
  s.description = "TODO: Description of Granted."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 3.2.14"

  s.add_development_dependency "sqlite3"
end
