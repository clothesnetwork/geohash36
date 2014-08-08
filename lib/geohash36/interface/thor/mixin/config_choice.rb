#!/usr/bin/env ruby

# @module     module Mixin
# @brief    Mixin module contains various functions to be used in other components
module Mixin

  # @module   ConfigChoice Module
  # @brief    Module wrapper around ConfigChoice tasks
  module ConfigChoice

    def config_choice
      defaults = YAML.load_file(File.expand_path( File.dirname( __FILE__ ) + '/../../../template/default_values.yml'))
      defaults['jason'].each_key { |key| choice_option(defaults['jason'], key) }
      defaults
    end

    private def choice_option(defaults, option)
      print ("%s (%s): " % [option, defaults[option]])
      value = STDIN.gets.chomp
      defaults[option] = value unless value.empty?
    end
  end # of module ConfigChoice

end # of module Mixin


# vim:ts=2:tw=100:wm=100:syntax=ruby