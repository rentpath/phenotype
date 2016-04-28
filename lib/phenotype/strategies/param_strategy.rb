require 'rack'
module Phenotype
  class ParamStrategy
    attr_reader :param
    def initialize(param = 'v')
      @param = param
    end

    def version(env)
      Rack::Request.new(env).params[param]
    end
  end
end
