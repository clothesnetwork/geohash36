#!/usr/bin/env ruby


# System
require 'shellwords'
require 'fileutils'

require 'ronn'
require 'rdiscount'


### Actions

# Set manual building deps
task :build   => [ 'man:clean', 'man:build' ]
task :release => [ 'man:clean', 'man:build' ]
task :clean   => [ 'man:clean' ]

namespace :man do

  desc 'Build the manual pages' # {{{
  task :build do

    # Sanity
    raise ArgumentError, '@gem_name is not defined, cannot proceed' if( @gem_name.nil? )
    raise ArgumentError, '@organization is not defined, cannot proceed' if( @organization.nil? )

    # Make sure man output/input dirs exists
    Dir.mkdir( "lib/#{@gem_name}/man" ) unless( Dir.exists?( "lib/#{@gem_name}/man" ) )
    Dir.mkdir( "lib/#{@gem_name}/manual" ) unless( Dir.exists?( "lib/#{@gem_name}/manual" ) )

    Dir.chdir "lib/#{@gem_name}/manual" do

      Dir[ '*.ronn' ].each do |ronn|

        basename  = File.basename( ronn, '.ronn' )
        roff      = "../man/#{basename}"

        # Unix runoff manual
        sh "ronn --roff --organization '#{@organization}' --pipe #{ronn} > #{roff}"

        # Human readable output
        sh "groff -Wall -mtty-char -mandoc -Tascii #{roff} | col -b > #{roff}.txt"

      end # of Dir['*.ronn']
    end # of Dir.chdir
  end # of task :build }}}

  desc "Clean up from the built man pages" # {{{
  task :clean do

    # Sanity
    raise ArgumentError, '@gem_name is not defined, cannot proceed' if( @gem_name.nil? )

    rm_rf "lib/#{@gem_name}/man"
  end # }}}

end # of namespace :man


# vim:ts=2:tw=100:wm=100:syntax=ruby
