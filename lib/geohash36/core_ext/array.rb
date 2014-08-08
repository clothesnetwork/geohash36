#!/usr/bin/env ruby


# @class        class Array
# @brief        
class Array

  class << self

    # @fn         def delete_unless &block {{{
    # @brief      Inverted #delete_if function for convenience
    #
    def delete_unless &block
      delete_if{ |element| not block.call( element ) }
    end # }}}

    # @fn         def %(len) {{{
    # @brief      Chunk array into convienent sub-chunks
    #
    # @credit     http://drnicwilliams.com/2007/03/22/meta-magic-in-ruby-presentation/
    #             direct original source at http://redhanded.hobix.com/bits/matchingIntoMultipleAssignment.html
    #
    # now e.g. this is possible
    #
    # ["foo0", "foo1", "foo2", "foo3", "foo4", "foo5", "foo6", "foo7", "foo8", "foo9", "foo10"]
    # [ ["foo0", "foo1", "foo2"], ["foo3", "foo4", "foo5"], ["foo6", "foo7", "foo8"], ["foo9", "foo10"]]
    #
    def %(len)
      inject([]) do |array, x|
        array << [] if [*array.last].nitems % len == 0
        array.last << x
        array
      end
    end # }}}

    # @fn         def sum {{{
    def sum
      inject( nil ) { |sum,x| sum ? sum+x : x }
    end # }}}

    # @fn         def mean {{{
    # @brief      
    def mean
      sum / size
    end # }}}

  end # of class << self
end # of class Array


# vim:ts=2:tw=100:wm=100
