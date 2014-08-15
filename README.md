# Geohash36
Version 0.3.0-9-g34a816a

Geohash36 is a complete solution for geohashing coordinates. What is geohash?
For example, the coordinate pair 40.689167, -74.044444 (NY City) produces a slightly shorter hash 9LVB4BH89g, which can be used in the URL http://geo36.org/9LVB4BH89g

The main usages of Geohashes are
* as a unique identifier.
* represent point data e.g. in databases.

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

Basic usage can be found in demo.rb file

## Copyright

Please refer to the COPYRIGHT file
