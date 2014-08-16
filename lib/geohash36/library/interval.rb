#!/usr/bin/env ruby

# @class      class Geohash36::Interval < Array
# @brief      Designed to provide additional functionality for arrays to handle geographical intervals.
class Geohash36::Interval < Array

  # @fn       def initialize array = [0, 0], options = {} {{{
  # @brief    Default constructor for Interval class
  #
  # @param    [Array<Fixnum, Float>]    array       Array with length 2.
  # @param    [Hash]                    options     Hash containing default opts
  #
  # @info     Options affects borders in interval. By default, all borders are included.
  #           If you want to exclude left border, pass: `include_left: false`
  #           If you want to exclude right border, pass: `include_right: false`
  #
  # @example  With default args
  #           Geohash36::Interval.new
  # @example  With array and options
  #           Geohash36::Interval.new([0, 6], include_right: false)
  #
  def initialize array = [0, 0], options = {}
    array.try( :compact! )
    validate_array( array )
    array.each{ |element| self.push element }
    defaults  = { include_right: true, include_left: true }
    @opts     = defaults.merge options
  end # of def initialize }}}

  # @fn       def configure options = {} {{{
  # @brief    Replace old interval options with new one
  #
  # @param    [Hash]    options     New options for interval
  def configure options = {}
    @opts.merge! options
  end # of def configure }}}

  # @fn       def include? number {{{
  # @brief    Check if `number` between left and right border
  #
  # @param    [Numeric]     number      Number to check
  def include? number
    for_left_border  = (@opts[:include_left] == true)  ? first  <= number : first < number
    for_right_number = (@opts[:include_right] == true) ? number <= last  : number < last
    for_left_border && for_right_number
  end # }}}

  # @fn       def split {{{
  # @brief    Split interval into 6 parts
  #
  # @return   [Array]     Array of 6 intervals
  def split
    split3.each_with_object([]){|interval, result| result.concat interval.split2}
  end # }}}

  # @fn       def update array {{{
  # @brief    Change values of interval
  #
  # @param    [Array]     array     FIXME
  #
  # @example  my_interval = Geohash36::Interval.new([0, 1])
  #           my_interval.update [0,6]
  #           my_interval # => [0, 6]
  def update array
    array.try(:compact!)
    validate_array(array)
    self.clear
    array.each{|element| self.push element}
  end # }}}

  # @fn       def inspect {{{
  # @brief    Returns string for easy inspection of self on print
  #
  # @return   [String]      String representation of object
  def inspect
    left_br  = @opts[:include_left]  ? "[" : "("
    right_br = @opts[:include_right] ? "]" : ")"

    "#{left_br}#{first}, #{last}#{right_br}"
  end # }}}

  # @fn       def to_s {{{
  # @brief    Returns string representation of self for print
  #
  # @return   [String]    String representation of object
  def to_s
    inspect
  end # }}}

  # @fn       def middle {{{
  # @brief    Average of given interval (middle)
  #
  # @return   [Numeric]     Returns average of the given interval
  #
  # @example  Geohash36::Interval.new([0, 6]).middle
  #             => 3.0
  def middle
    (first + last)/2.0
  end # }}}

  # @fn       def third {{{
  # @brief    Computes third part of given interval and returns absolute result
  #
  # @return   [Numeric]     Third part of interval (absolute, returns only positive values)
  #
  # @example  Geohash36::Interval.new([-2, 4]).third
  #             => 2.0
  #
  def third
    ((last - first)/3.0).abs
  end # }}}

  # @fn       def split2 {{{
  # @brief    Split interval into 2 parts
  #
  # @return   [Array]       Array of 2 intervals
  def split2
    [[first, middle], [middle, last]].map{|interval| Geohash36::Interval.new interval}
  end # }}}

  # @fn       def split3 {{{
  # @brief    Split interval into 3 parts
  #
  # @return   [Array]     Returns array of 3 intervals
  def split3
    result = [[self.first, self.first+third], [self.first+third, self.first+2*third], [self.first+2*third, self.last]]
    result.map{|array| Geohash36::Interval.new array}
  end # }}}

  # @fn       def self.convert_array array, options = {} {{{
  # @brief    Convert array of arrays to array of `Geohash36::Interval`s
  #
  # @param    [Array]     array       Array to convert
  # @param    [Hash]      options     Options for `Geohash36::Interval` object
  #
  # @info     It works a little different. It is not affect first\last elements in array.
  #           For example, if we do not want to include left border, only first element
  #           will include left border because this class designed to handle geographical coordinates.
  #           It is not designed for abstract intervals.
  #
  # @example  e.g. We don't want to include left border of interval,
  #           so we will have array like `[[0, 0], [0, 0], [0, 0]] ->> [[0, 0], (0, 0], (0, 0]]`
  #
  #           my_array = [[0, 2], [2, 6], [6, 10]]
  #           Geohash36.convert_array(my_array, include_left: false)
  #             => [[0, 2], (2, 6], (6, 10]]
  #
  def self.convert_array array, options = {}
    intervals = array.map{|interval| Geohash36::Interval.new interval, options }
    intervals.first.configure(include_left: true) unless options[:include_left]
    intervals.last.configure(include_right: true) unless options[:include_right]
    intervals
  end # }}}


  private

  # @fn       def validate_array array # {{{
  # @brief    Check if array has valid values
  #
  # @param    [Array]     array     FIXME
  def validate_array array
    unless array.length == 2 && ( array.try(:first) <= array.try(:last) )
      raise ArgumentError, "Not valid array for geohash interval"
    end
  end # }}}


end # of class Geohash36::Interval


# vim:ts=2:tw=100:wm=100:syntax=ruby
