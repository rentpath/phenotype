module Phenotype
  class AcceptHeaderStrategy
    attr_reader :mime_type

    def initialize(mime_type = "application/vnd.rentpath.api+json")
      @mime_type = mime_type
    end

    def version(env)
      env['HTTP_ACCEPT'].to_s.match(/#{Regexp.quote(mime_type)};version=(?<version>\d+)/) { |match| match[:version] }
    end
  end
end
