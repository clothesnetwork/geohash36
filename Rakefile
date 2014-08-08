#!/usr/bin/env ruby


# System
require 'bundler'
require 'bundler/gem_tasks'

require 'shellwords'
require 'fileutils'
require 'yaml'

require 'date'
require 'ostruct'

require 'ronn'
require 'rdiscount'

require 'benchmark'


### Project Customization for Thor and Rake

project = YAML.load_file( '.project.yaml' )
project.each_pair { |name, value| self.instance_variable_set( "@#{name.to_s}", value ) }


### General


### Actions


### Helper Functions


### Load all Rake file tasks
Dir.glob( "{,lib/}#{@gem_name}/interface/rake/**/*.{rake,rb}" ) { |name| load name }


# vim:ts=2:tw=100:wm=100:syntax=ruby
