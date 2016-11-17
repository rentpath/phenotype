require 'rspec'
require 'require_all'
require 'phenotype'
require 'rack'

RSpec.configure do |config|
  config.formatter = config.files_to_run.one? ? :documentation : :progress
end
