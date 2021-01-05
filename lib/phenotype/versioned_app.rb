# frozen_string_literal: true

require_relative 'versioner'
require_relative 'route_handler'

module Phenotype
  class VersionedApp
    attr_accessor :strategies, :routes

    def initialize(strategies: [])
      @routes = {}
      @strategies = strategies
    end

    def add_strategy(strategy)
      strategies.push(strategy)
    end

    def add_version(version:, cascade: false, &block)
      raise 'Error - Phenotype version must be numeric' unless version.is_a?(Numeric)

      routes[version] = RouteHandler.new(cascade: cascade, block: block)
    end

    def call(env)
      Versioner.new(routes: routes, strategies: strategies, env: env).call
    end
  end
end
