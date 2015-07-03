module Genius
  class Annotation < Resource
    attr_reader :verified_by, :share_url, :body, :votes_total, :comment_count,
                :state, :authors, :current_user_metadata, :id, :url

    def parse_resource!
      @verified_by = Account.from_hash(resource["verified_by"])
      @share_url = resource["share_url"]
      @body = formatted_attribute("body")
      @votes_total = resource["votes_total"]
      @comment_count = resource["comment_count"]
      @authors = resource["authors"]
      @state = resource["state"]
      @current_user_metadata = resource["current_user_metadata"]
      @id = resource["id"]
      @url = resource["url"]
    end

    def update!(body = {})
      response = self.class.http_put("/annotations/#{id}",
                                     body: body,
                                     headers: self.class.default_headers)

      self.class.new(response, text_format: text_format)
    end

    def destroy!
      self.class.http_delete("/annotations/#{id}", headers: self.class.default_headers)

      true
    end

    def upvote!
      self.class.http_put("/annotations/#{id}/upvote",
                          headers: self.class.default_headers)

      true
    end

    def unvote!
      self.class.http_put("/annotations/#{id}/unvote",
                          headers: self.class.default_headers)

      true
    end

    def downvote!
      self.class.http_put("/annotations/#{id}/downvote",
                          headers: self.class.default_headers)

      true
    end

    def self.create!(body = {})
      new(http_post("/annotations", body: body, headers: default_headers))
    end
  end
end
