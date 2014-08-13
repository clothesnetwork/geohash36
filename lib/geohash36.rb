# Standard library includes
require 'bundler'
require 'thor'
require 'rake'

require 'ruby-try'

# @module         module geohash36
# @brief          geohash36 modules and classes namespace
class Geohash36

  G = self
  GEOCODE_MATRIX = [
    ['2', '3', '4', '5', '6', '7'],
    ['8', '9', 'b', 'B', 'C', 'd'],
    ['D', 'F', 'g', 'G', 'h', 'H'],
    ['j', 'J', 'K', 'l', 'L', 'M'],
    ['n', 'N', 'P', 'q', 'Q', 'r'],
    ['R', 't', 'T', 'V', 'W', 'X']
  ]
  GEOMATRIX_MAX_INDEX = 5
  GEOCODE_LENGTH = 10
  DEFAULT_ACCURACY = 6

  attr_reader :coords
  attr_reader :hash
  attr_accessor :accuracy

  def initialize(obj = { latitude: 0, longitude: 0 })
    @accuracy = DEFAULT_ACCURACY
    if obj.kind_of? Hash
      @hash = G.to_geohash(obj)
      @coords = obj
    elsif obj.kind_of? String
      G.validate_geohash(obj)
      @hash = obj
      @coords = G.to_coords(obj, @accuracy)
    else
      raise ArgumentError, "Argument type should be hash or string"
    end
  end

  def hash=(geohash)
    raise ArgumenError unless geohash.kind_of? String
    @hash = geohash
    @coords = G.to_coords(geohash, @accuracy)
  end

  def coords=(coords)
    raise ArgumenError unless coords.kind_of? Hash
    @hash = G.to_geohash(coords)
    @coords.merge! coords
  end

  def self.geohash_symbol!(lon_interval, lat_interval, coords)
    lon_intervals = G::Interval.convert_array(lon_interval.split, include_right: false)
    lat_intervals = G::Interval.convert_array(lat_interval.split, include_left: false)

    lon_index = lon_intervals.index {|interval| interval.include? coords[:longitude] }
    lat_index = lat_intervals.index {|interval| interval.include? coords[:latitude]  }

    lon_interval.update lon_intervals[lon_index]
    lat_interval.update lat_intervals[lat_index]

    GEOCODE_MATRIX[GEOMATRIX_MAX_INDEX-lat_index][lon_index]
  end

  def self.to_geohash(coords)
    lon_interval = G.basic_lon_interval
    lat_interval = G.basic_lat_interval

    (0...GEOCODE_LENGTH).map{G.geohash_symbol!(lon_interval, lat_interval, coords)}.join
  end

  def self.to_coords(geohash, accuracy = DEFAULT_ACCURACY)
    G.validate_geohash(geohash)

    lon_interval = G.basic_lon_interval
    lat_interval = G.basic_lat_interval

    geohash.each_char do |c|
      lon_intervals = G::Interval.convert_array(lon_interval.split)
      lat_intervals = G::Interval.convert_array(lat_interval.split)

      lat_index, lon_index = 0, 0

      GEOCODE_MATRIX.each_with_index do |row, row_index|
        if row.include? c
          lat_index = GEOMATRIX_MAX_INDEX-row_index
          lon_index = row.index(c)
          break
        end
      end

      lon_interval.update lon_intervals[lon_index]
      lat_interval.update lat_intervals[lat_index]
    end

    { latitude:  lat_interval.middle.round(accuracy) ,
      longitude: lon_interval.middle.round(accuracy) }
  end

  private
    def self.basic_lon_interval
      G::Interval.new [-180, 180]
    end

    def self.basic_lat_interval
      G::Interval.new [-90, 90]
    end

    def self.validate_geohash(geohash)
      unless geohash =~ /\A[23456789bBCdDFgGhHjJKlLMnNPqQrRtTVWX]+{1,10}\z/
        raise ArgumentError, "It is not Geohash-36."
      end
    end

end # of module Geohash36

Dir[File.dirname(__FILE__) + '/geohash36/library/*.rb'].each {|file| require file }

# vim:ts=2:tw=100:wm=100:syntax=ruby
