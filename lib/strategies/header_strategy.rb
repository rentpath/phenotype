module Phenotype 
  class HeaderStrategy
    attr_reader :header, :header_param, :env
    def initialize(header: 'Sue')
      @header = header
    end

    def get_version(env)
      @env ||= env 
      version
    end

    def version 
      @version ||= env[header_key]
    end

    private
    def header_key
      "HTTP_#{header.upcase}"
    end
  end
end
