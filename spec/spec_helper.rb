require 'bundler/setup'
Bundler.setup

require 'geohash36'

RSpec.configure do |c|
  c.mock_with :rspec
end