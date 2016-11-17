require_relative 'response_handler'

module Phenotype
  class Versioner
    attr_reader :routes, :versions, :strategies, :env

    def initialize(routes: {}, strategies: [], env: {})
      @routes = routes
      @versions = routes.keys.sort.reverse
      @strategies = strategies
      @env = env
    end

    def call
      return display_errors if errors?
      cascading_versions.each do |v|
        route = call_route(v)
        handler = ResponseHandler.new(route.block.call(env))
        return handler.response unless route.cascade? && handler.retry?
      end
    end

    private

    def errors?
      strategies.empty? || too_many_strategies? || !supported_version?
    end

    def display_errors
      return no_strategy_response.call(env) if strategies.empty?
      return too_many_strategies_response.call(env) if too_many_strategies?
      return version_not_found_response.call(env) unless supported_version?
    end

    def too_many_strategies?
      @too_many_strategies ||= strategies.size > 1
    end

    def supported_version?
      @supported_version ||= versions.include?(current_version)
    end

    def current_version
      @current_version ||= strategies.detect { |strat| strat.version(env) }.version(env).to_i
    end

    def cascading_versions
      @cascading_versions ||= versions.select { |el| el <= current_version }
    end

    def no_strategy_response
      @no_strategy_response ||= default_response(406, 'No Strategies provided')
    end

    def too_many_strategies_response
      @too_many_strategies_response ||= default_response(400, 'Too mant strategies provided, Supports only one')
    end

    def version_not_found_response(message = "Version: #{current_version} is not found")
      default_response(406, message)
    end

    def call_route(version)
      routes.fetch(
        version,
        version_not_found_response("Unable to satisfy request for Version: #{current_version}")
      )
    end

    def default_response(status_code, message = '')
      proc { [status_code, { 'Content-Type' => 'text/html' }, [message]] }
    end
  end
end
