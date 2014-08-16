#!/usr/bin/env ruby

# Custom include
require_relative 'geohash36'

puts '-'*90
puts 'FROM COORDS TO GEOHASH'
puts '-'*90

[{latitude: 0, longitude: 0},
{latitude: 54, longitude: 32},
{latitude: 40.710489, longitude: -74.015612},
{latitude: 53.907095, longitude: 27.558915},
{latitude: 40.689167, longitude: -74.044444}].each do |coords|
  puts "#{Geohash36.to_geohash(coords)} for coords: #{coords}"
end

puts '-'*90
puts "FROM HASH TO COORDS"
puts '-'*90

["l222222222222", "BB99999999999", "9LV5V9V4CqbJh", "BbCBt9BQ7N4Wb"].each do |hash|
  puts "#{Geohash36.to_coords(hash)} for geohash #{hash}"
end

