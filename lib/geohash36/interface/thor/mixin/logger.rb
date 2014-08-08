#!/usr/bin/env ruby


# System includes
require 'thor'
require 'andand'

# Custom includes
require File.expand_path( File.dirname( __FILE__ ) + '/../../../library/logger' )


# @module       module Mixin
# @brief        Mixin module contains various functions to be used in other components
module Mixin

  # @module     Logger Module
  # @brief      Module wrapper around logger tasks
  module Logger

    # @fn       def initialize *args {{{
    # @brief    Default constructor
    #
    # @param    [Array]     args      Argument array
    def initialize *args
      super

      @logger           = ::ClothesNetwork::Logger.instance

      @logger.color     = options[ :colorize ]
      @logger.silent    = options[ :silent ]

    end # }}}

    Thor::class_option :colorize, :type => :boolean, :required => false, :default => true,  :desc => 'Colorize the output for easier reading'
    Thor::class_option :logger,   :type => :boolean, :required => false, :default => true,  :desc => 'Use default project logger'
    Thor::class_option :silent,   :type => :boolean, :required => false, :default => false, :desc => 'Turn off all logging'

  end # of module Logger

end # of module Mixin


# vim:ts=2:tw=100:wm=100:syntax=ruby
