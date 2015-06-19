require 'httparty'

module Genius
  class Artist < Resource
    attr_reader :name, :image_url, :id, :url, :user, :tracking_paths

    def parse_resource!
      @id = resource["id"]
      @name = resource["name"]
      @image_url = resource["image_url"]
      @url = resource["url"]
      @user = resource["user"]
      @description = formatted_attribute("description")
      @tracking_paths = resource["tracking_paths"]
    end

    def songs(params: {})
      headers = self.class.default_headers.merge(params.delete(:headers))
      params = self.class.default_params.merge(id: id).merge(params)

      self.class.http_get("/#{resource_name}s/#{id}/songs", query: params,
                                                            headers: headers)
    end
  end
end
