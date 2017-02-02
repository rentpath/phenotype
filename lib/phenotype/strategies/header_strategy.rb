module Phenotype
  class HeaderStrategy
    attr_reader :header
    def initialize(header: 'Sue')
      @header = header
    end

    def version(env)
      env["HTTP_#{header.upcase}"] || NullStrategy.new
    end
  end
end
