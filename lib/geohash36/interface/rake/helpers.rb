#!/usr/bin/env ruby


# System
require 'shellwords'
require 'fileutils'

require 'date'
require 'ostruct'



### Actions

desc "Look for TODO and FIXME tags in the code" # {{{
task :todo do
    egrep /(FIXME|TODO|TBD|FIXME1|FIXME2|FIXME3)/
end # }}}

desc "Git Tag number of this repo" # {{{
task :version do |t|
  # sh 'git describe --abbrev=0 --tags'
  sh 'git describe --tags'
end # }}}


# vim:ts=2:tw=100:wm=100:syntax=ruby
