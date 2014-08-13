require 'bundler/setup'
require 'rspec/mocks'
require 'rspec/its'
require 'rspec/expectations'
require 'ruby-try'
require 'simplecov'

require 'geohash36'

Bundler.setup


RSpec.configure do |config|

  # Use color in STDOUT
  config.color = true

  # Use color not only in STDOUT but also in pagers and files
  config.tty = true

  # Use the specified formatter
  config.formatter = :documentation # :progress, :html, :textmate

  config.expect_with :rspec do |c|
    c.syntax = [:should, :expect] # Disable warnings
  end

  config.mock_with :rspec do |c|
    c.syntax = [:should, :expect] # Disable warnings
  end
end

# Because of buggy standart include() matcher
RSpec::Matchers.define :include? do |expected|
  match do |actual|
    actual.include? expected
  end

  description do
    "include #{expected}"
  end
end


SimpleCov.profiles.define 'geohash36' do
  add_filter '/spec/'
end

SimpleCov.start 'geohash36'
