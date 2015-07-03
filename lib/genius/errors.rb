module Genius
  class Error < StandardError; end
  class NotFoundError < Error; end
  class AuthenticationError < Error; end
  class MissingAccessTokenError < Error; end
  class NotReloadableError < Error; end
end
