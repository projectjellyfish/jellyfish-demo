$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'jellyfish_demo/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'jellyfish-demo'
  s.version     = JellyfishDemo::VERSION
  s.authors     = ['mafernando']
  s.email       = ['fernando_michael@bah.com']
  s.homepage    = 'http://projectjellyfish.org'
  s.summary     = 'Jellyfish Demo Extension'
  s.description = 'An Extension to demo Jellyfish capabilities.'
  s.license     = 'APACHE'
  s.files       = Dir['{app,config,db,lib}/**/*', 'LICENSE', 'Rakefile', 'README.md']
  s.add_dependency 'rails'
end
