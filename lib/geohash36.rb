# Standard library includes
require 'bundler'
require 'thor'
require 'rake'

require 'ruby-try'

# @module         module geohash36
# @brief          geohash36 modules and classes namespace
class Geohash36

  GEOCODE_MATRIX = [
    ['2', '3', '4', '5', '6', '7'],
    ['8', '9', 'b', 'B', 'C', 'd'],
    ['D', 'F', 'g', 'G', 'h', 'H'],
    ['j', 'J', 'K', 'l', 'L', 'M'],
    ['n', 'N', 'P', 'q', 'Q', 'r'],
    ['R', 't', 'T', 'V', 'W', 'X']
  ]
  GEOMATRIX_MAX_INDEX = 5

  attr_reader :coords
  attr_reader :hash
  attr_accessor :accuracy

  def initialize(obj = { latitude: 0, longitude: 0 })
    @accuracy = 6
    if obj.kind_of? Hash
      @hash = to_geohash(obj)
      @coords = obj
    elsif obj.kind_of? String
      @hash = obj
      @coords = to_coords(obj)
    else
      raise ArgumentError, "Argument type should be hash or string"
    end
  end

  def hash=(geohash)
    raise ArgumenError unless geohash.kind_of? String
    @hash = geohash
    @coords = to_coords(geohash)
  end


  def coords=(coords)
    raise ArgumenError unless coords.kind_of? Hash
    @hash = to_geohash(coords)
    @coords.merge! coords
  end

  def geohash_symbol(horiz_interval, vert_interval, coords)
    vert = coords[:latitude]
    horiz = coords[:longitude]

    horiz_intervals = Geohash36::Interval.convert_array(horiz_interval.split, include_right: false)
    vert_intervals  = Geohash36::Interval.convert_array(vert_interval.split, include_left: false)

    horiz_index = horiz_intervals.find_index  {|interval| interval.include? horiz }
    vert_index  = vert_intervals.find_index  {|interval| interval.include? vert  }

    { symbol: GEOCODE_MATRIX[GEOMATRIX_MAX_INDEX-vert_index][horiz_index],
      horiz_interval: horiz_intervals[horiz_index],
      vert_interval: vert_intervals[vert_index] }
  end

  def to_geohash(coords)
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
          latitude_index = GEOMATRIX_MAX_INDEX-index
          longitude_index = row.find_index {|symbol| symbol == c}
        end
      end
      horiz_interval = horiz_intervals[longitude_index]
      vert_interval = vert_intervals  [latitude_index]
    end

    { latitude: vert_interval.middle.round(@accuracy) , longitude: horiz_interval.middle.round(@accuracy) }
  end

end # of module Geohash36

Dir[File.dirname(__FILE__) + '/geohash36/library/*.rb'].each {|file| require file }

# vim:ts=2:tw=100:wm=100:syntax=ruby
