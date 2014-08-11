require 'ruby-try'
require_relative 'geohash36'
require_relative 'geohash36/library/interval'


GEOCODE_MATRIX = [
  '2', '3', '4', '5', '6', '7',
  '8', '9', 'b', 'B', 'C', 'd',
  'D', 'F', 'g', 'G', 'h', 'H',
  'j', 'J', 'K', 'l', 'L', 'M',
  'n', 'N', 'P', 'q', 'Q', 'r',
  'R', 't', 'T', 'V', 'W', 'X'
]

def to_geohash(coords) # hash required
  lat  = coords[:latitude]
  long = coords[:longitude]
end

def to_coords(geohash)
  horiz_interval = [-180, 180]
  vert_interval = []

  unless geohash =~ /\A[23456789bBCdDFgGhHjJKlLMnNPqQrRtTVWX]+{1,36}\z/
    raise ArgumentError, "It is not Geohash-36."
  end


end

i = Geohash36::Interval.new [0, 6]
puts i.split2.to_s
puts i.split3.to_s
puts i.split.to_s
