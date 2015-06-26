require "genius/version"
require "genius/errors"
require "genius/resource"
require "genius/artist"
require "genius/song"
require "genius/web_page"
require "genius/account"
require "genius/annotation"
require "genius/referent"

module Genius
  class << self
    attr_accessor :access_token
    attr_writer   :text_format

    PLAIN_TEXT_FORMAT = "plain".freeze

    def text_format
      @text_format || PLAIN_TEXT_FORMAT
    end
  end
end
