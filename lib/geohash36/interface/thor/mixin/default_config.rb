#!/usr/bin/env ruby

# Custom includes
require File.expand_path( File.dirname( __FILE__ ) + '/config_choice' )

# @module       module Mixin
# @brief        Mixin module contains various functions to be used in other components
module Mixin

  # @module     DefaultConfig Module
  # @brief      Module wrapper around default tasks
  module DefaultConfig

    # Include various partials
    include ::Mixin::ConfigChoice

    def defaults
      config_path = File.expand_path( '~/.scylla/config.yml' )
      if File.exists?(config_path)
        YAML.load_file(config_path)
      else
        FileUtils.mkdir_p( File.expand_path( '~/.scylla' ) )
        config_choice
      end
    end
  end # of module DefaultConfig

end # of module Mixin


# vim:ts=2:tw=100:wm=100:syntax=ruby
