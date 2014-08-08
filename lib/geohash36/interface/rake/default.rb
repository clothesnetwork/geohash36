#!/usr/bin/env ruby


# System
require 'bundler'
require 'bundler/gem_tasks'

require 'shellwords'
require 'fileutils'

require 'date'
require 'ostruct'



### General

desc "Show the default task when executing rake without arguments" # {{{
task :default => :help # }}}

desc "Shows the usage help screen" # {{{
task :help do |t|
  `rake -T`
end # }}}



# vim:ts=2:tw=100:wm=100:syntax=ruby
