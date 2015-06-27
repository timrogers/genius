module Genius
  class WebPage < Resource
    resource_name "web_page"

    attr_reader :id, :url, :title, :normalized_url, :domain, :share_url, :annotation_count

    def parse_resource!
      @id = resource["id"]
      @url = resource["url"]
      @title = resource["title"]
      @normalized_url = resource["normalized_url"]
      @domain = resource["domain"]
      @share_url = resource["share_url"]
      @annotation_count = resource["annotation_count"]
    end

    def self.find(*)
      raise NotImplementedError, "A Web Page cannot be loaded by its ID in the public API"
    end

    def reload
      raise NotReloadableError, "A Web Page cannot be reloaded"
    end

    def self.lookup(params = {})
      headers = default_headers.merge(params.delete(:headers) || {})
      params = default_params.merge(params)

      new(http_get("/#{resource_name}s/lookup",
                   query: params,
                   headers: headers),
          text_format: params[:text_format])
    end
  end
end
