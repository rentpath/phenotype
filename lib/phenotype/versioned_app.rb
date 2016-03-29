module Phenotype
  class VersionedApp
    attr_accessor :strategies, :routes
    attr_writer :no_strategy_response, :too_many_strategies_response, :version_not_found_response

    def initialize(strategies: [])
      @routes = {}
      @strategies = strategies
    end

    def add_strategy(strat)
      strategies.push(strat)
    end

    def add_version(version:, &block)
      routes[version] = block
    end

    def call(env)
      strats = strategies.find_all { |strat| strat.version(env) }
      return no_strategy_response.call(env) if strategies.empty?
      return too_many_strategies_response.call(env) if strategies.size > 1
      call_route(strats.first.version(env)).call(env)
    end

    private
    def no_strategy_response
      @no_strategy_response ||= default_response(406)
    end

    def too_many_strategies_response
      @too_many_strategies_response ||= default_response(400)
    end

    def version_not_found_response
      @version_not_found_response ||= default_response(406)
    end

    def call_route(version)
      routes.fetch(version, version_not_found_response)
    end

    def default_response(status_code)
      Proc.new { [status_code, { 'Content-Type' => 'text/html', 'Content-Length' => "#{status_code}".size.to_s}, ["#{status_code}"]] }
    end
  end
end

