lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fishistory/version'

Gem::Specification.new do |gem|
  gem.name           =  'fishistory'
  gem.version        =  Fishistory::VERSION
  gem.date           =  '2015-09-04'
  gem.summary        =  'Save, parse, and provide stats for your fish history'
  gem.description    =  'TODO: Add description'
  gem.authors        =  ["Nate Collings"]
  gem.email          =  'nate@natecollings.com'
  gem.homepage       =  'https://github.com/naiyt/fishistory'
  gem.license        =  'MIT'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec)/})
  gem.require_paths = ["lib"]

  gem.required_ruby_version = '>= 2.1.5'
  gem.add_dependency 'activerecord', '>= 4.0.0'

  gem.add_development_dependency 'rspec', '>= 3.0.0'
  gem.add_development_dependency 'pry'
end

