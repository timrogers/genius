module Genius
  class NotFoundError < StandardError; end
  class AuthenticationError < StandardError; end
  class MissingAccessTokenError < StandardError; end
  class NotReloadableError < StandardError; end
end
