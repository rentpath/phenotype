# frozen_string_literal: true

module Phenotype
  class PathStrategy
    attr_reader :version_pattern

    def initialize(version_pattern = Regexp.new('^\/v(\d+)\/?'))
      @version_pattern = version_pattern
    end

    def version(env)
      match = Rack::Request.new(env).path.match(version_pattern)
      match && match[1] || NullStrategy.new
    end
  end
end
