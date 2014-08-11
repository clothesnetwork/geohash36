class Geohash36::Interval < Array
  attr_reader :opts

  def initialize(array = [0, 0], options = {})
    array.try(:compact!)
    raise ArgumentError, "Not valid array for geohash interval" unless array.length == 2
    array.each{|element| self.push element}
    defaults = {include_right: true, include_left: true }
    @opts = defaults.merge options
  end

  def include?(number)
    for_left_border  = (@opts[:include_left] == true)  ? first  <= number : first < number
    for_right_number = (@opts[:include_right] == true) ? number <= last  : number < last
    for_left_border && for_right_number
  end

  def split
    split3.each_with_object([]){|interval, result| result.concat interval.split2}
  end

  def middle
    (first + last)/2.0
  end

  def third
    (first + last)/3.0
  end

  def split2
    Geohash36::Interval.new [[first, middle], [middle, last]]
  end

  def split3
    result = [[self.first, third], [third, 2*third], [2*third, self.last]]
    result.map{|array| Geohash36::Interval.new array}
  end
end
