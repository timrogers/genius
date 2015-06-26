module Genius
  class Artist < Resource
    attr_reader :name, :image_url, :id, :url, :user, :tracking_paths, :description

    def parse_resource!
      @id = resource["id"]
      @name = resource["name"]
      @image_url = resource["image_url"]
      @url = resource["url"]
      @user = Account.from_hash(resource["user"])
      @description = formatted_attribute("description")
      @tracking_paths = resource["tracking_paths"]
    end

    def songs(params: {}, headers: {})
      headers = self.class.default_headers.merge(headers)
      params = self.class.default_params.merge(id: id).merge(params)

      response = self.class.http_get("/#{resource_name}s/#{id}/songs", query: params,
                                                                       headers: headers)

      response.parsed_response["response"]["songs"].map do |song|
        Song.from_hash(song, text_format: text_format)
      end
    end
  end
end
