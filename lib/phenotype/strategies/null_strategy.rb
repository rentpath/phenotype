module Phenotype
  class NullStrategy
    def version(env)
      self
    end

    def to_i
      nil
    end
  end
end
