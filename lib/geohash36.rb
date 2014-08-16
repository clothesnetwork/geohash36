#!/usr/bin/env ruby

# Standard includes
require 'bundler'
require 'thor'
require 'rake'
require 'ruby-try'


# @class    Geohash36
# @brief    Provides complete solution for geohashing
class Geohash36

  # Geocode-36 matrix for map
  GEOCODE_MATRIX = [
    ['2', '3', '4', '5', '6', '7'],
    ['8', '9', 'b', 'B', 'C', 'd'],
    ['D', 'F', 'g', 'G', 'h', 'H'],
    ['j', 'J', 'K', 'l', 'L', 'M'],
    ['n', 'N', 'P', 'q', 'Q', 'r'],
    ['R', 't', 'T', 'V', 'W', 'X']
  ]

  # Needed for inversion direction of latitude
  GEOMATRIX_MAX_INDEX = 5

  # Standart length of geocode
  GEOCODE_LENGTH      = 10

  # Accuracy for coordinates when converting from geohash
  DEFAULT_ACCURACY    = 6

  attr_reader   :coords, :hash
  attr_accessor :accuracy

  # @fn       def initialize obj = { latitude: 0, longitude: 0 } {{{
  # @brief    Create new Geohash object from geohash or coordinates.
  #
  # @param    [Hash or String]    object    Either Hash {latitude: value, longitude: value} or "geohash string"
  #
  # @example  Pass geohash
  #           Geohash36.new "l222222222222"
  # @example  Pass coordinates
  #           Geohash36.new latitude: 80, longitude: 20
  #
  def initialize obj = { latitude: 0, longitude: 0 }
    @accuracy = DEFAULT_ACCURACY

    if obj.kind_of? Hash
      Geohash36.validate_coords( obj )
      @hash   = Geohash36.to_geohash( obj )
      @coords = obj
    elsif obj.kind_of? String
      Geohash36.validate_geohash( obj )
      @hash   = obj
      @coords = Geohash36.to_coords( obj, @accuracy )
    else
      raise ArgumentError, "Argument type should be hash or string"
    end
  end # of def initialize }}}

  # @fn       def hash=(geohash) {{{
  # Update geohash value. Coordinates will update automatically
  def hash=(geohash)
    raise ArgumenError unless( geohash.kind_of?( String ) )
    @hash   = geohash
    @coords = Geohash36.to_coords( geohash, @accuracy )
  end # of def hash= }}}

  # @fn       def coords=(coords) {{{
  # @brief    Update coordinates values. Geohash will update automatically
  #
  # @param    [Hash]      coords      Hash containing keys longitude, latitude with corresponding values.
  #
  def coords=(coords)
    raise ArgumenError unless( coords.kind_of?( Hash ) )
    @hash = Geohash36.to_geohash( coords )
    @coords.merge! coords
  end # }}}

  # @fn       def self.to_geohash coords {{{
  # @brief    Convert coordinates pair to geohash without creating an object
  #
  # @param    [Hash]    coords      Coordinates to convert
  #
  # @return   [String]  Returns a geohash from given coordinates
  #
  # @example  Geohash36.to_geohash(latitude: 0, longitude: 0)
  #           # => "l222222222"
  def self.to_geohash coords
    Geohash36.validate_coords(coords)
    lon_interval = Geohash36.basic_lon_interval
    lat_interval = Geohash36.basic_lat_interval

    (0...GEOCODE_LENGTH).map{Geohash36.geohash_symbol!(lon_interval, lat_interval, coords)}.join
  end # }}}

  # @fn       def self.to_coords(geohash, accuracy = DEFAULT_ACCURACY) {{{
  # @brief    Convert geohash to coords without creating an object.
  #
  # @param    [String]      geohash       Given geohash string
  # @param    [Fixnum]      accuracy      Accuracy for coordinates values
  #
  # @return   [Hash]        Returns coordinates from given hash
  #
  # @example  With default accuracy
  #           Geohash36.to_coords("l222222222")
  #             => {:latitude=>-1.0e-06, :longitude=>3.0e-06}
  # @example  With accuracy 3
  #           Geohash36.to_coords("l222222222", 3)
  #             => {:latitude=>0.0, :longitude=>0.0}
  #
  def self.to_coords geohash, accuracy = DEFAULT_ACCURACY
    Geohash36.validate_geohash(geohash)

    lon_interval    = Geohash36.basic_lon_interval
    lat_interval    = Geohash36.basic_lat_interval

    geohash.each_char do |c|
      lon_intervals = Geohash36::Interval.convert_array(lon_interval.split)
      lat_intervals = Geohash36::Interval.convert_array(lat_interval.split)

      lat_index, lon_index = 0, 0

      GEOCODE_MATRIX.each_with_index do |row, row_index|
        if row.include?( c )
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
  end # }}}


  private

  # @fn       def self.basic_lon_interval {{{
  # @brief    Returns basic Longitude interval allowed
  #
  # @return   [Interval]      Returns correctly initialized Interval class for Longitude
  def self.basic_lon_interval
    Geohash36::Interval.new [-180, 180]
  end # }}}

  # @fn       def self.basic_lat_interval {{{
  # @brief    Returns basic Latitude interval allowed
  #
  # @return   [Interval]      Returns correctly initialized Interval class for Latitude
  def self.basic_lat_interval
    Geohash36::Interval.new [-90, 90]
  end # }}}

  def self.validate_geohash geohash
    unless geohash =~ /\A[23456789bBCdDFgGhHjJKlLMnNPqQrRtTVWX]+{1,10}\z/
      raise ArgumentError, "Sorry, it doesn't seem to be Geohash-36"
    end
  end

  def self.validate_coords coords
    keys = coords.keys
    raise ArgumentError, "Invalid hash" unless keys.length == 2 && keys.include?(:latitude) && keys.include?(:longitude)
    lat_inclusion = Geohash36.basic_lat_interval.include? coords[:latitude]
    lon_inclusion = Geohash36.basic_lon_interval.include? coords[:longitude]
    raise ArgumentError, "Invalid hash values" unless lat_inclusion && lon_inclusion
  end

  def self.geohash_symbol! lon_interval, lat_interval, coords
    lon_intervals = Geohash36::Interval.convert_array(lon_interval.split, include_right: false)
    lat_intervals = Geohash36::Interval.convert_array(lat_interval.split, include_left: false)

    lon_index = lon_intervals.index {|interval| interval.include? coords[:longitude] }
    lat_index = lat_intervals.index {|interval| interval.include? coords[:latitude]  }

    lon_interval.update lon_intervals[lon_index]
    lat_interval.update lat_intervals[lat_index]

    GEOCODE_MATRIX[GEOMATRIX_MAX_INDEX-lat_index][lon_index]
  end

end # of module Geohash36

Dir[ File.dirname(__FILE__) + '/geohash36/library/*.rb' ].each { |file| require file }

# vim:ts=2:tw=100:wm=100:syntax=ruby
