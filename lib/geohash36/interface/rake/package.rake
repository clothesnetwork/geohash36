#!/usr/bin/env ruby


# System
require 'shellwords'
require 'fileutils'

require 'ronn'
require 'rdiscount'


### Actions

# Set manual building deps
task :clean   => [ 'package:clean' ]

namespace :package do

  desc 'Clean all files from pkg folder' # {{{
  task :clean do

    rm_rf 'pkg/*'

  end # of task :clean }}}

end # of namespace :package


# vim:ts=2:tw=100:wm=100:syntax=ruby
