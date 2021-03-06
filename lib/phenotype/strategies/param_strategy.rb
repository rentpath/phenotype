# frozen_string_literal: true

module Phenotype
  class ParamStrategy
    attr_reader :param

    def initialize(param = 'v')
      @param = param
    end

    def version(env)
      Rack::Request.new(env).params[param] || NullStrategy.new
    end
  end
end
