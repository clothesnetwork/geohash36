#!/usr/bin/env ruby


# @module       module Mixin
# @brief        Mixin module contains various functions to be used in other components
module Mixin

  # @module     Configuration Module
  # @brief      Module wrapper around tasks which demands config file
  module Configuration

    # @fn       def initialize *args {{{
    # @brief    Default constructor
    #
    # @param    [Array]     args      Argument array
    def initialize *args
      super
      unless File.exist?("~/.geohash36/config.yaml")
          abort("Could not find configuration file in ~/geohash36/config.yaml. Please run 'geohash36 config:generate' to generate it.")
      end
    end # }}}

  end # of module Configuration

end # of module Mixin


# vim:ts=2:tw=100:wm=100:syntax=ruby
