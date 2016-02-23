require 'rack'
module Phenotype 
  class ParamStrategy
    attr_reader :param, :request
    def initialize(param = 'v')
      @param = param
    end

    def get_version(env)
      @request = Rack::Request.new(env)
      version
    end

    def version
      @version ||= request.params[param]
    end
  end
end
