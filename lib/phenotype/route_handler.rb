# frozen_string_literal: true

module Phenotype
  class RouteHandler
    attr_reader :cascade, :block

    def initialize(block:, cascade: false)
      @cascade = cascade
      @block = block
    end

    def cascade?
      cascade
    end
  end
end
