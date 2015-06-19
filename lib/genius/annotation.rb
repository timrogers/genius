require 'httparty'

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
  end
end
