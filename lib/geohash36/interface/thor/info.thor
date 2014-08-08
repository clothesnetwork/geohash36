#!/usr/bin/env ruby


# System includes
require 'ostruct'
require 'awesome_print'
require 'andand'
require 'tempfile'
require 'os'

# Custom includes
require File.expand_path( File.dirname( __FILE__ ) + '/mixin/shell' )


# @class  Info command class
# @brief  Implements the info command
class Info < Thor

  include ::Mixin::Shell
  # include ::Mixin::Command

  default_task :info

  class_option :'without-general',  :type => :boolean, :desc => "Print general system environment information"
  class_option :'without-project',  :type => :boolean, :desc => "Print project environment information"
  class_option :'without-ruby',     :type => :boolean, :desc => "Print ruby environment information"

  class_option :pretty,             :type => :boolean, :desc => "Pretty print"


  ## API

  # @fn       def info {{{
  # @brief    Main info task entry point
  desc "overview", "Shows system overview"
  def overview

    # Default symbol action list to find info for
    default = %i(
                  general
                  project
                  ruby 
                )

    # Make sure if we have a --without-* opts to skip work
    options.each_pair do |option, skip|
      next unless( skip )
      default.delete_if { |item| option =~ %r{#{item.to_s}}i }
    end

    # Execute scan & print
    default.each do |item|
      data = scan_for item
      next if data.andand.broken.nil?

      self.send :pretty_print, data
    end # of default.each

  end # }}}


  private

  no_tasks do

    ## Actions

    # @fn       def scan_for what # {{{
    # @brief    When executed will run "what" method scanner and print relevant information
    #
    # @param    [Symbol]        what        Symbol of scanner method to run, e.g. :general, :java, :ruby etc.
    def scan_for what
      result            = nil

      begin
        result          = self.send what
      rescue Exception => e
        say "(EE) " + e.message, :red
        result          = OpenStruct.new
        result.broken   = true
      end

      return result
    end # }}}

    # @fn       def pretty_print information, playful = options[:pretty] # {{{
    # @brief    Pretty prints given data to stdout
    #
    # @param    [OpenStruct]    information       Information gathered from other scanning methods, e.g. :ruby
    # @param    [Boolean]       playful           Prints some curses like lines if true
    def pretty_print information, playful = options[:pretty]
      begin
        puts ""
        say information.title, :yellow

        if( playful )
          puts "-"*26
          puts " "*26 + "\\"
        else
          puts ""
        end

        values = information.send :table
        raise ArgumentError, "Information openstruct is malformed" if( values[ :broken ] )

        values.each do |key, value|

          # Skip :broken, :title
          next if( %i(title broken).include?( key.to_sym ) )

          # Make sure value is a string
          value = value.to_s

          # Remove pre- and post-padding
          value.strip!

          # Turn key into a nice printable value
          # e.g. :current_directory => Current directory
          description = key.to_s
          description.gsub!( "_", " " )
          description.capitalize!


          # Check if value is multi-line, if so, format accordingly
          output = []

          if( value =~ %r{\n} )
            lines     = value.split( "\n" )
            output    << sprintf( "%-25s | %s", description, lines.shift )
            lines.each { |line| output << sprintf( "%-25s | %s", "", line ) }
          else
            output    << sprintf( "%-25s | %s", description, value )
          end

          output.each { |something| say something }
        end

        if( playful )
          puts " "*26 + "\\"
          puts " "*27 + "-"*80
        end

        puts ""

      rescue Exception => e
        say "(EE) " + e.message, :red
      end
    end # }}}


    ## Specific Scanners

    # @fn       def general {{{
    # @brief    Returns information collected from the general system
    #
    # @return   [OpenStruct]      Returns openstruct with gathered information
    def general
      result                  = nil

      begin
        result                = OpenStruct.new
        result.broken         = false

        os                    = os_report

        result.title          = "System Information"
        result.system         = os.host
        result.cpus           = OS.cpu_count
        result.architecture   = OS.bits
        result.current_user   = `whoami`.chomp

      rescue Exception => e
        result                = OpenStruct.new
        result.broken         = true

        say "(EE) " + e.message, :red
      end

      return result
    end # }}}

    # @fn       def project {{{
    # @brief    Print project related information to stdout
    #
    # @return   [OpenStruct]      Returns openstruct with gathered information
    def project
      result                      = nil

      begin
        result                    = OpenStruct.new
        result.broken             = false

        result.title              = "Project information"

        result.current_directory  = Dir.pwd
        result.version            = `git describe --tags` || "unknown"

      rescue Exception => e
        result                    = OpenStruct.new
        result.broken             = true

        say "(EE) " + e.message, :red
      end

      return result
    end # }}}

    # @fn       def ruby {{{
    # @brief    Prints ruby environment information to stdout
    #
    # @return   [OpenStruct]      Returns openstruct with gathered information
    def ruby

      result                  = nil

      begin
        result                = OpenStruct.new
        result.broken         = false

        result.title          = 'Ruby Information'

        commands              = %w(ruby rvm rbenv rake gem)

        commands.each do |command|
          next unless( self.which( command ) )

          result.send "#{command}=", self.version( command )
        end

      rescue Exception => e
        result                = OpenStruct.new
        result.broken         = true

        say "(EE) " + e.message, :red
      end

      return result
    end # }}}


    ## Helpers

    # @fn       def os_report {{{
    # @brief    Get overview of the Operating System
    #
    # @return   [OpenStruct]      Returns a openstruct with various information, e.g.
    #                             arch, target_os, target_vendor, target_cpu, target, host_os, host_vendor, host_cpu, host, RUBY_PLATFORM
    def os_report
      result    = nil

      begin
        yaml    = OS.report
        hash    = YAML.load( yaml )
        result  = hashes_to_ostruct( hash )
      rescue Exception => e
        $stderr.puts set_color "(EE) #{e.message}", :red
      end

      result
    end # }}}

    # @fn       def hashes_to_ostruct object # {{{
    # @brief    This function turns a nested hash into a nested open struct
    #
    # @author   Dave Dribin
    #           Reference: http://www.dribin.org/dave/blog/archives/2006/11/17/hashes_to_ostruct/
    #
    # @param    [Object]    object    Value can either be of type Hash or Array, if other then it is returned and not changed
    #
    # @return   [OStruct]             Returns nested open structs
    def hashes_to_ostruct object

      return case object
      when Hash
        object = object.clone
        object.each { |key, value| object[key] = hashes_to_ostruct(value) }
        OpenStruct.new( object )
      when Array
        object = object.clone
        object.map! { |i| hashes_to_ostruct(i) }
      else
        object
      end

    end # of def hashes_to_ostruct }}}

  end # of no_tasks do

end # of Class Info


# vim:ts=2:tw=100:wm=100:syntax=ruby
