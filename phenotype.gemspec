require './lib/util/version'

Gem::Specification.new do |s|
  s.name = 'phentoype'
  s.homepage = ''
  s.version = Phenotype::VERSION
  s.authors = ['Rentpath']
  s.summary = "phentoype-#{Phenotype::VERSION}"
  s.description= "versioning gem that works with rails and rack"
  s.license = "NA"
  s.files = Dir['lib/**/*']
  s.rdoc_options = ['--charset=UTF-8']
  s.require_paths = ['lib']

  s.add_dependency 'require_all'
  s.add_dependency 'rack'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rake'
end
