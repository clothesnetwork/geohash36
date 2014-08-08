require 'bundler/setup'
Bundler.setup

require 'scylla'

RSpec.configure do |c|
  c.mock_with :rspec
end