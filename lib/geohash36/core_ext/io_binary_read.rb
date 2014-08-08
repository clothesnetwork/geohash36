#!/usr/bin/env ruby


# @class      class IO #:nodoc:
#
# @credit     https://github.com/erikhuda/thor/blob/master/lib/thor/core_ext/io_binary_read.rb
class IO

  class << self
    def binread(file, *args)
      fail ArgumentError, "wrong number of arguments (#{1 + args.size} for 1..3)" unless args.size < 3
      File.open(file, "rb") do |f|
        f.read(*args)
      end
    end unless method_defined? :binread
  end

end # of class IO

# vim:ts=2:tw=100:wm=100
