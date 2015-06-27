module Genius
  class Referent < Resource
    attr_reader :id, :url, :song_id, :annotator_id, :fragment, :range, :classification,
                :annotatable, :annotations

    def self.find(*)
      raise NotImplementedError, "A Referent cannot be loaded by its ID in the public API"
    end

    def self.where(params = {})
      headers = default_headers.merge(params.delete(:headers) || {})
      params = default_params.merge(params)

      response = http_get("/#{resource_name}s/", query: params, headers: headers)

      response.parsed_response["response"]["referents"].map do |referent|
        self.from_hash(referent, text_format: params[:text_format])
      end
    end

    def reload
      raise NotReloadableError, "A Referent cannot be reloaded"
    end

    def parse_resource!
      @url = resource["url"]

      @annotations = resource["annotations"].map do |annotation|
        Annotation.from_hash(annotation)
      end

      @song_id = resource["song_id"]
      @annotator_id = resource["annotator_id"]
      @fragment = resource["fragment"]
      @range = resource["range"]
      @classification = resource["classification"]
      @annotatable = resource["annotatable"]
      @id = resource["id"]
    end

    def song
      return nil unless song_id
      Song.find(song_id)
    end
  end
end
