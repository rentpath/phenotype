module Phenotype
  class RouteHandler
    attr_reader :cascade, :block

    def initialize(cascade: false, block:)
      @cascade = cascade
      @block = block
    end

    def cascade?
      cascade
    end
  end
end
