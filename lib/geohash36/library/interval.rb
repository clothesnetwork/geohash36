#!/usr/bin/env ruby


# @fn       class Interval < Array 
# @brief    Interval class handling intervall calculation
class Geohash36::Interval < Array

  def initialize array = [0, 0], options = {}
    array.try(:compact!)
    validate_array(array)
    array.each{|element| self.push element}
    defaults = {include_right: true, include_left: true }
    @opts = defaults.merge options
  end

  def configure options = {}
    @opts.merge! options
  end

  def include? number
    for_left_border  = (@opts[:include_left] == true)  ? first  <= number : first < number
    for_right_number = (@opts[:include_right] == true) ? number <= last  : number < last
    for_left_border && for_right_number
  end

  def split
    split3.each_with_object([]){|interval, result| result.concat interval.split2}
  end

  def update array
    array.try(:compact!)
    validate_array(array)
    self.clear
    array.each{|element| self.push element}
  end

  def inspect
    left_br  = @opts[:include_left]  ? "[" : "("
    right_br = @opts[:include_right] ? "]" : ")"
    "#{left_br}#{first}, #{last}#{right_br}"
  end

  def to_s
    inspect
  end

  def middle
    (first + last)/2.0
  end

  def third
    ((last - first)/3.0).abs
  end

  def split2
    Geohash36::Interval.new [[first, middle], [middle, last]]
  end

  def split3
    result = [[self.first, self.first+third], [self.first+third, self.first+2*third], [self.first+2*third, self.last]]
    result.map{|array| Geohash36::Interval.new array}
  end

  def self.convert_array array, options = {}
    intervals = array.map{|interval| Geohash36::Interval.new interval, options }
    intervals.first.configure(include_left: true) unless options[:include_left]
    intervals.last.configure(include_right: true) unless options[:include_right]
    intervals
  end

  private

  def validate_array array
    raise ArgumentError, "Not valid array for geohash interval" unless array.length == 2
  end

end # of class Geohash36::Interval


# vim:ts=2:tw=100:wm=100:syntax=ruby
