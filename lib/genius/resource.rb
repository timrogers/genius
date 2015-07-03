require 'httparty'

module Genius
  class Resource
    include HTTParty

    base_uri 'https://api.genius.com'
    format   :json

    attr_reader :raw_response, :resource

    def self.resource_name(resource_name = nil)
      @resource_name = resource_name if resource_name
      @resource_name || name.downcase.split("::").last
    end

    def self.find(id, params: {}, headers: {})
      params = default_params.merge(params)
      headers = default_headers.merge(headers)

      new(http_get("/#{resource_name}s/#{id}",
                   query: params,
                   headers: headers),
          text_format: params[:text_format])
    end

    def reload
      self.class.find(id, params: { text_format: text_format })
    end

    def self.http_get(path, query: {}, headers: {})
      response = get(path, query: query, headers: headers)
      handle_response(response)
    end

    def self.http_post(path, body: {}, headers: {})
      response = post(path, body: body, headers: headers)
      handle_response(response)
    end

    def self.http_put(path, body: {}, headers: {})
      response = put(path, body: body, headers: headers)
      handle_response(response)
    end

    def self.http_delete(path, headers: {})
      response = delete(path, headers: headers)
      handle_response(response)
    end

    def self.handle_response(response)
      case response.code
      when 404 then raise NotFoundError
      when 401, 403 then raise AuthenticationError
      else response
      end
    end

    def self.default_params
      {
        text_format: Genius.text_format
      }
    end

    def self.default_headers
      {
        'Authorization' => "Bearer #{Genius.access_token}",
        'User-Agent' => "genius.rb v#{Genius::VERSION}"
      }
    end

    def initialize(response, text_format: Genius.text_format, resource: nil)
      @raw_response = response
      @resource = resource || response.parsed_response["response"][resource_name]
      @text_format = text_format

      parse_resource!
    end

    def self.from_hash(attributes, text_format: Genius.text_format)
      return nil unless attributes
      new(nil, text_format: text_format, resource: attributes)
    end

    private

    attr_reader :text_format

    def resource_name
      self.class.resource_name
    end

    # Fetches an attribute that uses the API's Text Formatting feature, which means that
    # the attribute will be nested inside a key naming the format (plain/html/dom)
    def formatted_attribute(attribute)
      return nil unless resource[attribute]
      resource[attribute][text_format]
    end
  end
end
