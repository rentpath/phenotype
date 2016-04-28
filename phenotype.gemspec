require './lib/phenotype/version'

Gem::Specification.new do |s|
  s.name = 'phenotype'
  s.homepage = ''
  s.version = Phenotype::VERSION
  s.authors = ['Rentpath']
  s.summary = "phenotype-#{Phenotype::VERSION}"
  s.description= "versioning gem that works with rails and rack"
  s.license = "NA"
  s.files = Dir['lib/**/*']
  s.rdoc_options = ['--charset=UTF-8']
  s.require_paths = ['lib']

  s.add_dependency 'require_all', '~> 1.3'
  s.add_dependency 'rack', '~> 1.6'
  s.add_development_dependency 'pry', '~> 0.10'
  s.add_development_dependency 'rspec', '~> 3.4'
  s.add_development_dependency 'rake', '~> 10.5'
end
