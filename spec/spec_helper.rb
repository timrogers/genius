$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'genius'
require 'mocha/api'
require 'webmock/rspec'
require 'rspec/its'

Dir[File.expand_path('../support/**/*.rb', __FILE__)].each { |f| require f }

RSpec.configure do |config|
  config.mock_framework = :mocha
end
