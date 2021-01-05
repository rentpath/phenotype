# frozen_string_literal: true

module Phenotype
  class ResponseHandler
    attr_reader :response

    def initialize(response)
      @response = response
    end

    def retry?
      valid_response? && not_found? && cascade?
    end

    private

    def valid_response?
      response.is_a?(Array) && rack_response?
    end

    def rack_response?
      response[0].is_a?(Numeric) && response[1].is_a?(Hash) && response[2].is_a?(Array)
    end

    def not_found?
      response.first.to_i == 404
    end

    def cascade?
      response[1]['X-Cascade'].to_s == 'pass'
    end
  end
end
