module Phenotype
  class AcceptHeaderStrategy
    attr_reader :env, :content_type, :version_key

    def initialize(app_name: 'rentpath',
                   version_key: 'version', 
                   format: 'json')
      @version_key = version_key
      @content_type = build_content_type(app_name, format)
    end

    def get_version(env)
      @env = env
      version
    end

    def version
      version_content = accept_header_hash[content_type]
      return unless version_content
      version_content.split("#{version_key}=")[1]
    end

    private
    def build_content_type(app_name, format)
      "application/vnd.#{app_name}.api+#{format}"
    end

    def accept_header_hash
      accepted_content.reduce({}) do |header_hash, content|
        key, value = content.split(';')
        header_hash[key] = value
        header_hash
      end
    end

    def accepted_content
      accept_header = env['HTTP_ACCEPT']
      return [] unless accept_header 
      accept_header.strip.split(',')
    end
  end
end
