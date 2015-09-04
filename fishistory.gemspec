Gem::Specification.new do |gem|
  gem.name           =  'fishistory'
  gem.version        =  '0.0.1'
  gem.date           =  '2015-09-04'
  gem.summary        =  'Save, parse, and provide stats for your fish history'
  gem.description    =  'TODO: Add description'
  gem.files          =  ["lib/fishistory.rb"]
  gem.authors        =  ["Nate Collings"]
  gem.email          =  'nate@natecollings.com'
  gem.homepage       =  'https://github.com/naiyt/fishistory'
  gem.license        =  'MIT'

  gem.required_ruby_version = '>= 2.1.5'
  gem.add_dependency 'activerecord', '>= 4.0.0'

  gem.add_development_dependency 'rspec', '>= 3.0.0'
  gem.add_development_dependency 'pry'
end

