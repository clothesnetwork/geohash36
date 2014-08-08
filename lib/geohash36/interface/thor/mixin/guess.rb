#!/usr/bin/env ruby


# System includes
require 'andand'


# @module     module Mixin
# @brief      Mixin module contains various functions to be used in other components
module Mixin

  # @module   Guess Module
  # @brief    Module wrapper around guess tasks to extract version numbers etc
  module Guess

    # @fn       def initialize *args {{{
    # @brief    Default constructor
    #
    # @param    [Array]     args      Argument array
    def initialize *args
      super
    end # }}}

    # @fn       def guess_version string {{{
    # @brief    Guess version from full version string
    #
    # @example  e.g. "ruby 2.1.1p76 (2014-02-24 revision 45161) [i686-linux]"
    #                   -> 2.1.1
    #
    #                "rake, version 10.1.1"
    #                   -> 10.1.1
    def guess_version string

      result      = ""

      begin

        # Sanity
        raise ArgumentError, "Version has to be of type string" unless( string.is_a?( String ) )
        raise ArgumentError, "Version can't be empty" if( string.empty? )

        result    = string.match( /\d+\.\d+\.\d+/ ).to_s # matches first only

      rescue Exception => e
        say "(EE) " + e.message, :red
        result    = ""
      end

      return result
    end # }}}

  end # of Module Guess

end # of module Mixin


# vim:ts=2:tw=100:wm=100:syntax=ruby
