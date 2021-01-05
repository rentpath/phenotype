# frozen_string_literal: true

module Phenotype
  class NullStrategy
    def version(_env)
      self
    end

    def to_i
      nil
    end
  end
end
