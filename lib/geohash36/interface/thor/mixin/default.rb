#!/usr/bin/env ruby


# System includes
require 'thor'
require 'andand'


# @module       module Mixin
# @brief        Mixin module contains various functions to be used in other components
module Mixin

  # @module     Default Module
  # @brief      Module wrapper around default tasks
  module Default

    # @fn       def initialize *args {{{
    # @brief    Default constructor
    #
    # @param    [Array]     args      Argument array
    def initialize *args
      super
    end # }}}

  end # of module Default

end # of module Mixin


# vim:ts=2:tw=100:wm=100:syntax=ruby
