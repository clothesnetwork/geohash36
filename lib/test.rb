require 'ruby-try'
require_relative 'geohash36'
require_relative 'geohash36/library/interval'


GEOCODE_MATRIX = [
  ['2', '3', '4', '5', '6', '7'],
  ['8', '9', 'b', 'B', 'C', 'd'],
  ['D', 'F', 'g', 'G', 'h', 'H'],
  ['j', 'J', 'K', 'l', 'L', 'M'],
  ['n', 'N', 'P', 'q', 'Q', 'r'],
  ['R', 't', 'T', 'V', 'W', 'X']
]

def geohash_symbol(horiz_interval, vert_interval, coords)
  vert = coords[:latitude]
  horiz = coords[:longitude]

  horiz_intervals = Geohash36::Interval.convert_array(horiz_interval.split, include_right: false)
  vert_intervals  = Geohash36::Interval.convert_array(vert_interval.split, include_left: false)

  horiz_index = horiz_intervals.find_index  {|interval| interval.include? horiz }
  vert_index  = vert_intervals.find_index  {|interval| interval.include? vert  }

  { symbol: GEOCODE_MATRIX[5-vert_index][horiz_index],
    horiz_interval: horiz_intervals[horiz_index],
    vert_interval: vert_intervals[vert_index] }
end

def to_geohash(coords) # hash required
  horiz_interval = Geohash36::Interval.new [-180, 180]
  vert_interval =  Geohash36::Interval.new [-90, 90]
  geohash = ""

  (0..9).each do
    result = geohash_symbol(horiz_interval, vert_interval, coords)
    horiz_interval = result[:horiz_interval]
    vert_interval  = result[:vert_interval]
    geohash << result[:symbol]
  end
  geohash
end

def to_coords(geohash)
  horiz_interval = Geohash36::Interval.new [-180, 180]
  vert_interval =  Geohash36::Interval.new [-90, 90]

  unless geohash =~ /\A[23456789bBCdDFgGhHjJKlLMnNPqQrRtTVWX]+{1,10}\z/
    raise ArgumentError, "It is not Geohash-36."
  end

  geohash.each_char do |c|
    horiz_intervals = Geohash36::Interval.convert_array(horiz_interval.split)
    vert_intervals  = Geohash36::Interval.convert_array(vert_interval.split)

    latitude_index = 0
    longitude_index = 0
    GEOCODE_MATRIX.each_with_index do |row, index|
      if row.any? {|symbol| symbol == c}
        latitude_index = 5-index
        longitude_index = row.find_index {|symbol| symbol == c}
      end
    end
    horiz_interval = horiz_intervals[longitude_index]
    vert_interval = vert_intervals  [latitude_index]
  end

  { latitude: vert_interval.middle.round(6) , longitude: horiz_interval.middle.round(6) }
end

puts to_geohash latitude: 0, longitude: 0
puts to_geohash latitude: 54, longitude: 32
puts to_geohash latitude: 40.710489, longitude: -74.015612
puts to_geohash latitude: 53.907095, longitude: 27.558915
puts to_geohash latitude: 40.689167, longitude: -74.044444

["l222222222222", "BB99999999999", "9LV5V9V4CqbJh", "BbCBt9BQ7N4Wb"].each do |hash|
  puts to_coords(hash)
end
