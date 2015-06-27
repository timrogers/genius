module Genius
  class Account < Resource
    resource_name "user"

    attr_reader :unread_messages_count, :artist, :role_for_display, :iq,
                :unread_main_activity_inbox_count, :avatar, :about_me,
                :tracking_paths, :id, :current_user_metadata, :login, :name

    def parse_resource!
      @unread_messages_count = resource["unread_messages_count"]
      @artist = resource["artist"]
      @role_for_display = resource["role_for_display"]
      @unread_main_activity_inbox_count = resource["unread_main_activity_inbox_count"]
      @avatar = resource["avatar"]
      @about_me = formatted_attribute("about_me")
      @identities = resource["identities"]
      @name = resource["name"]
      @tracking_paths = resource["tracking_paths"]
      @id = resource["id"]
      @current_user_metadata = resource["current_user_metadata"]
      @iq = resource["iq"]
      @login = resource["login"]
    end

    def reload
      raise NotReloadableError, "An Account cannot be reloaded"
    end

    def self.find(*)
      raise NotImplementedError, "An Account cannot be loaded by its ID in the public API"
    end

    def self.me(params = {})
      headers = default_headers.merge(params.delete(:headers) || {})
      params = default_params.merge(params)

      new(http_get("/account", query: params,
                               headers: headers),
          text_format: params[:text_format])
    end
  end
end
