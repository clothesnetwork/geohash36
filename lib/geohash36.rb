#!/usr/bin/env ruby


# Standard library includes
require 'bundler'
require 'thor'
require 'rake'

# Custom library includes
require_relative 'geohash36/core_ext'


# @module         module geohash36
# @brief          geohash36 modules and classes namespace
module Geohash36

  require_relative 'geohash36/version'
  require_relative 'geohash36/error'

  # @module     module Mixin
  # @brief      Mixin module contains various functions to be used in other components
  module Mixin

    # autoload :Guess, 'geohash36/mixin/'

  end # of module Mixing

  # autoload :Cache,      'geohash36/library/cache'
  # autoload :Choice,     'geohash36/library/choice'


  DEFAULT_CONFIG      = '.geohash36/config.yaml'.freeze

  class << self

  end # of class << self

end # of module Geohash36



## Library
require_relative 'geohash36/library/dbc'
require_relative 'geohash36/library/helpers'
require_relative 'geohash36/library/logger'
require_relative 'geohash36/library/magic'


# vim:ts=2:tw=100:wm=100:syntax=ruby
