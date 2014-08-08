#!/usr/bin/env ruby


# System
require 'shellwords'
require 'fileutils'

require 'date'
require 'ostruct'



### Actions

namespace :readme do # {{{

  desc "Generate proper README file from templates" # {{{
  task :all => [ :topdir, :subdirs ] # }}}

  desc "Generate top level README file from template" # {{{
  task :topdir do |t|
    pwd         = Dir.pwd
    template    = "README.md.template"
    target      = "README.md"

    from        = File.join( pwd, template )
    to          = File.join( pwd, target )

    generate_readme( from, to )
  end # }}}

  desc "Builds generates readme files in all sub-directories" # {{{
  task :subdirs do |t|

    Dir.chdir( "src" ) do
      languages = Dir.glob( "*" )
      languages.each do |lang|
        Dir.chdir( lang ) do
          transports = Dir.glob( "*" )
          transports.each do |transport|
            Dir.chdir( transport ) do
              if( Dir.glob("*").include?( "README.md.template" ) )

                pwd         = Dir.pwd
                template    = "README.md.template"
                target      = "README.md"

                from        = File.join( pwd, template )
                to          = File.join( pwd, target )

                generate_readme( from, to )
              end
            end
          end # of Dir.chdir
        end # of Dir.chdir( lang )
      end # of languages.each
    end # of Dir.chdir

  end # of task :subdirs # }}}

end # of namespace # }}}


### Helper Functions

# @fn       def generate_readme source, target # {{{
# @brief    Generates given source readme into output target readme
#
# @param    [String]  source    Source readme, e.g. /foo/blah/README.md.template
# @param    [String]  target    Target readme, e.g. /foo/blah/README.md
#
def generate_readme source, target
  content     = File.readlines( source ).collect!{ |line| line.rstrip }
  version     = `git describe --tags`.strip
  rake_tasks  = `rake -T`
  thor_tasks  = `thor -T`

  content[ content.index( "$Version$" ) ] = "Version " + version if( content.include?( "$Version$" ) )
  content[ content.index( "$rake_tasks$" ) ] = rake_tasks.to_s if( content.include?( "$rake_tasks$" ) )
  content[ content.index( "$thor_tasks$" ) ] = thor_tasks.to_s if( content.include?( "$thor_tasks$" ) )
  File.write( target, content.join("\n") )
  puts "(II) #{target.to_s} generated from #{source.to_s}"
end # }}}


# vim:ts=2:tw=100:wm=100:syntax=ruby
