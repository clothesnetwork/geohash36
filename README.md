# Geohash36
Version 0.3.1

[![Gem Version](https://badge.fury.io/rb/geohash36.svg)](http://badge.fury.io/rb/geohash36)
[|[License](http://img.shields.io/badge/license-MIT-brightgreen.svg)](http://img.shields.io/badge/license-MIT-brightgreen.svg)

Geohash36 is a complete solution for geohashing coordinates. What is a geohash? For example, the
coordinate pair 40.689167, -74.044444 (NY City) produces a slightly shorter hash 9LVB4BH89g, which
can be used in the URL http://geo36.org/9LVB4BH89g

The main usages of Geohashes are

  * as a unique identifier
  * represent point data e.g. in databases


## More about geohashing

In order to describe any location on the planet we normally use Longitude and Latitude geo
coordinates. While working with two variables like this is fine, it is prone to certain issues such
as how to control arbitrary precision, ease or querying, means of finding locations of proximity,
having just one unique identifier and so on.

Out of this reason Gustavo Niemeyer created the Geohash [1][2] algorithm. It is a hierarchical spatial
data structure which subdivides space into buckets of grid shape. The two coordinate variables are
turned into one local perceptual hash, in which similar spaces share more significant string
similarity (from left to right).

This allows very easily to query for similar regions by left to right character matching and the
calculation of promimity by for instance edit distance. One can also imagine a efficient data
structure which utilizes a TRIE to store such coordinates.

Original Geohash algorithm is based on radix 32 system which leaves us with certain problems.
Geohash 36 [2] [3], originally developed for compression of world coordinate data, utilizes radix 36
notation allowing for higher precision and leverages a character set designed for electronic storage
and communication rather than human memory and conversation.

It uses an case sensitive alphabet of the characters "23456789bBCdDFgGhHjJKlLMnNPqQrRtTVWX" where
characters were chosen to avoid vowels, vowel-like numbers, character confusion, and to use
lowercase characters, which are generally distinct from their uppercase equivalents in standard
typefaces.

Alphabet conversion table [2]

Decimal     0   1   2   3   4   5   6   7   8   9   10  11  12  13  14  15  16  17

Geohash-36  2   3   4   5   6   7   8   9   b   B   C   d   D   F   g   G   h   H

Decimal     18  19  20  21  22  23  24  25  26  27  28  29  30  31  32  33  34  35

Geohash-36  j   J   K   l   L   M   n   N   P   q   Q   r   R   t   T   V   W   X

Each character represents a further subdivision in a 6 by 6 grid - starting at the North-West
(top-left) coordinate and continuing, row by row, to the South-East (bottom-right) [4].

The Statue of Liberty, at coordinates 40.689167, -74.044444, is encoded as 9LVB4BH89g-m. The reverse
decoding equates to 40.689168,-74.044445.

[1] http://geohash.org/

[2] http://en.wikipedia.org/wiki/Geohash

[2] http://en.wikipedia.org/wiki/Geohash-36

[3] http://geo36.org/

[4] http://www.pubnub.com/blog/wp-content/uploads/2014/05/ProximityChat1.jpg


## Installing

By running gem comand

```
gem install geohash36
```

or by adding to `Gemfile`

```ruby
gem 'geohash36', git: 'https://github.com/clothesnetwork/geohash36'
```

## Usage

As library


```ruby
2.1.2 :001 > require 'geohash36'
 => true
2.1.2 :002 > coordinates = { latitude: 40.689167, longitude: -74.044444 }
 => {:latitude=>40.689167, :longitude=>-74.044444}
2.1.2 :004 > hash = Geohash36.to_geohash( coordinates )
 => "9LVB4BH89g"
2.1.2 :005 > resolved = Geohash36.to_coords( hash )
 => {:latitude=>40.689168, :longitude=>-74.044445}
```

or from the command line

```sh
~# geohash36

Commands:
  geohash36 coords GEOHASH [ACCURACY]  # Get coordinates for geohash with specified accuracy
  geohash36 hash LATITUDE LONGITUDE    # Get geohash36 from coordinates
  geohash36 help [COMMAND]             # Describe available commands or one specific command
```

```sh
~# geohash36 hash 40.689167 -74.044445

9LVB4BH89g
```
```sh
~# geohash36 coords 9LVB4BH89g

Latitude: 40.689
Longitude: -74.044
```

## Contributing

1. Fork it ( https://github.com/clothesnetwork/geohash36/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request


## Authors

* [Oleg Orlov](https://github.com/OrelSokolov)
* [Bjoern Rennhak](https://github.com/rennhak)

## Copyright & License

Please refer to the COPYING.md and LICENSE.md file.
