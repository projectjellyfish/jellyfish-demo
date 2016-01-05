$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'jellyfish_demo/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'jellyfish-demo'
  s.version     = JellyfishDemo::VERSION
  s.authors     = ['Jerimiah Milton']
  s.email       = ['milton_jerimiah@bah.com']
  s.homepage    = 'http://github.com/projectjellyfish/jellyfish_demo'
  s.summary     = 'Adds sample data to Jellyfish.'
  s.description = 'Adds ... sample data to Jellyfish.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'rails', '~> 4.2.3'

  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'simplecov', '~> 0.10.0'
  s.add_development_dependency 'rspec-rails', '~> 3.0'
  s.add_development_dependency 'factory_girl_rails', '~> 4.0'
end
