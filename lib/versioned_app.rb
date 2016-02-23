module Phenotype 
  class VersionedApp
    attr_accessor :strategies, :default_routes, :routes
    def initialize(strategies: [])
      @routes = {}
      @strategies = strategies
      @default_routes = null_default 
    end

    def add_strategy(strat)
      strategies.push(strat)
    end

    def add_version(version: nil, default: false, &block)
      @default_routes = block if default
      routes[version] = block
    end

    def call(env)
      strategy = get_strategy(env)
      return default_routes.call(env) unless strategy.version
      call_route(strategy.version).call(env)
    end

    private
    def null_default
      Proc.new { [404, 
        { 'Content-Type' => 'text/html', 'Content-Length' => "404".size.to_s},
        ["404"]]
      }
    end

    def call_route(version)
      routes.fetch(version, default_routes)
    end

    def get_strategy(env)
      strategy = strategies.find { |strat| strat.get_version(env) } 
      strategy || NullStrategy.new 
    end
  end
end
