$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "searchify/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "searchify"
  s.version     = Searchify::VERSION
  s.authors     = ["Christian Blais", "Thierry Joyal"]
  s.email       = ["christ.blais@gmail.com", "thierry.joyal@gmail.com"]
  s.homepage    = "http://github.com/christianblais/searchify"
  s.summary     = "Search with ease!"
  s.description = "Searchify provides a quick way to search your collections."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails"
  s.add_dependency "jquery-rails"

  s.add_development_dependency "sqlite3"
end
