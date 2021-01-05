# frozen_string_literal: true

require './lib/phenotype/version'

Gem::Specification.new do |s|
  s.name = 'phenotype'
  s.homepage = 'https://github.com/rentpath/phenotype'
  s.version = Phenotype::VERSION
  s.authors = ['Rentpath']
  s.summary = "phenotype-#{Phenotype::VERSION}"
  s.description = 'versioning gem that works with rails and rack'
  s.license = 'MIT'
  s.files = Dir['lib/**/*']
  s.rdoc_options = ['--charset=UTF-8']
  s.require_paths = ['lib']
  s.required_ruby_version = '>= 2.4' # rubocop:disable Gemspec/RequiredRubyVersion

  s.add_dependency 'rack', '>= 1'
  s.add_dependency 'require_all', '>= 1.3'
  s.add_development_dependency 'pry', '>= 0.10'
  s.add_development_dependency 'rake', '>= 10.5'
  s.add_development_dependency 'rspec', '>= 3.4'
end
