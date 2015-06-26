module Genius
  class Song < Resource
    attr_reader :id, :url, :title, :media, :description_annotation, :annotation_count,
                :tracking_paths, :description, :bop_url, :header_image_url,
                :updated_by_human_at, :lyrics_updated_at, :pyongs_count, :stats,
                :current_user_metadata, :verified_annotations_by

    def self.search(query, params: {}, headers: {})
      headers = default_headers.merge(headers)
      params = default_params.merge(q: query).merge(params)

      response = http_get("/search", query: params, headers: headers)

      response["response"]["hits"].map do |hit|
        self.from_hash(hit["result"], text_format: params[:text_format])
      end
    end

    def parse_resource!
      @id = resource["id"]
      @url = resource["url"]
      @title = resource["title"]
      @media = resource["media"]
      @description_annotation = resource["description_annotation"]
      @annotation_count = resource["annotation_count"]
      @tracking_paths = resource["tracking_paths"]
      @description = formatted_attribute("description")
      @bop_url = resource["bop_url"]
      @header_image_url = resource["header_image_url"]

      if resource["updated_by_human_at"]
        @updated_by_human_at = Time.at(resource["updated_by_human_at"])
      end

      if resource["lyrics_updated_at"]
        @lyrics_updated_at = Time.at(resource["lyrics_updated_at"])
      end

      @pyongs_count = resource["pyongs_count"]
      @stats = resource["stats"]
      @current_user_metadata = resource["current_user_metadata"]
      @verified_annotations_by = resource["verified_annotations_by"]
    end

    def featured_artists
      @featured_artists ||= resource["featured_artists"].map do |artist|
        Artist.from_hash(artist)
      end
    end

    def producer_artists
      @featured_artists ||= resource["producer_artists"].map do |artist|
        Artist.from_hash(artist)
      end
    end

    def writer_artists
      @featured_artists ||= resource["writer_artists"].map do |artist|
        Artist.from_hash(artist)
      end
    end

    def primary_artist
      @primary_artist ||= Artist.from_hash(resource["primary_artist"])
    end
  end
end
