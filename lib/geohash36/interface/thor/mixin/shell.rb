#!/usr/bin/env ruby


# System includes
require 'andand'
require 'ptools'
require 'tempfile'

# Custom includes
require File.expand_path( File.dirname( __FILE__ ) + '/guess' )


# @module     module Mixin
# @brief      Mixin module contains various functions to be used in other components
module Mixin

  # @module   Shell Module
  # @brief    Module wrapper around shell commands
  module Shell

    include ::Mixin::Guess

    # @fn       def initialize *args {{{
    # @brief    Default constructor
    #
    # @param    [Array]     args      Argument array
    def initialize *args
      super
    end # }}}

    ## Actions

    # @fn       def run command {{{
    # @brief    Run the given command gracefully (without throwing exceptions)
    #
    # @param    [String]        command         The command to run
    # @param    [RegExp]        regexp          Optional regular expression used for matching output
    #
    # @return   [String]        Returns empty string if command not found or other problem,
    #                           otherwise result of command.
    def run command, regexp = nil

      result      = ''

      begin
        if( regexp.nil? )
          result  = execute( command ).strip
        else
          raise ArgumentError, 'Regular Expression input needs to be of type Regexp' unless( regexp.is_a?( Regexp ) )

          result  = execute( command ).andand.send( :match, regexp ).andand.send( :to_s ).strip
        end

      rescue Exception => e
        say '(EE) ' + e.message, :red
        result    = ''
      end

      return result
    end # }}}

    # @fn       def execute command {{{
    # @brief    Execute single shell command
    #
    # @param    [String]          command         Shell command string with arguments
    #
    # @return   [String]          Returns result of command
    #
    # @throws   [ArgumentError]   Throws exception if command not found
    def execute command

      exists  = which( command )
      raise ArgumentError, "Command not found" unless( exists )
      result  = `#{command}`

      return result
    end # }}}

    # @fn       def which command {{{
    # @brief    Checks if command is available
    #
    # @param    [String]        command         Shell command string with or without arguments.
    #                                           If arguments are given, they are split on first
    #                                           whitespace and discarded
    #
    # @return   [Boolean]       Returns boolean true if command is available, false if not
    #
    #
    # @info     Crude alternative: `#{command} 2>/dev/null`.strip.empty?
    def which command
      result      = false

      begin
        partial   = command.to_s
        partial   = partial.split(' ').first.to_s if( partial =~ %r{ }i )
        path      = File.which( partial )

        result    = true unless( path.nil? )
      rescue Exception => e
        say "(EE) " + e.message, :red
        result    = false
      end

      return result
    end # }}}

    # @fn       def version command {{{
    # @brief    Prints the version of given command, if command exists
    #
    # @param    [String]        command         Command string to probe version for, e.g. ruby
    #
    # @return   [String]        Returns version string or empty if command not found / error
    def version command

      result      = ""

      begin

        # Sanity
        raise ArgumentError, "Command not found" unless( which( command ) )

        # Get usage help screen for command
        help      = usage( command )

        # Get version flag from help screen
        flag      = version_flag( help )

        return result if( flag.empty? ) # some stupid commands don't follow standard rules, e.g. bundle

        # Get actual version string
        banner    = run( command + " " + flag )

        # Guess way to extract and extract semver
        result    = guess_version( banner.to_s )

      rescue Exception => e
        say "(EE) " + e.message, :red
        result    = ""
      end

      return result
    end # }}}


    alias_method :exists?, :which

    private

    # @fn       def usage command {{{
    # @brief    Extracts help/usage screen from command
    #
    # @param    [String]        command         Command string
    #
    # @return   [String         Result screen output string
    def usage command

      result        = ""

      begin

        # Some commands misbehave when using wrong arguments
        # e.g. java
        help        = []

        # Collect all possible outputs
        %w(--help -h -help).each do |argument|
          tempfile  = Tempfile.new( "scylla-" )
          `#{command} #{argument} > #{tempfile.path.to_s} 2>&1`
          help      <<  File.read( tempfile.path )
        end

        # Prune to relevent one
        help.each do |h|

          # Sanity
          next if( h.strip.empty? )
          next if( h.split( "\n" ).length < 4 )
          next unless( h.match( /unknown/i ).to_s.empty? )           # does it contain unknown? (argument)
          next unless( h.match( /unrecognized/i ).to_s.empty? )      # does it contain unrecognized? (argument)
          next unless( h.match( /error/i ).to_s.empty? )             # does it contain error
          next unless( h.match( /does not exist/i ).to_s.empty? )    # does not exist error
          next unless( result.empty? )

          result    = h

        end # of help.each


      rescue Exception => e
        say "(EE) " + e.message, :red
        result      = ""
      end

      return result
    end # }}}

    # @fn       def version_flag usage {{{
    # @brief    Extracts version flag from usage help screen of command
    #
    # @param    [String]        usage         Usage help screen output (string), e.g. ruby --help
    #
    # @return   [String]        Returns the string which according to help screen will print version
    #                           e.g. -version for java
    def version_flag usage

      result        = ""

      begin
        result      = usage.match( /--version/i ).to_s
        result      = usage.match( /-version/i ).to_s if( result.empty? )
      rescue Exception => e
        say "(EE) " + e.message, :red
        result      = ""
      end

      return result
    end # }}}

  end # of Module Shell

end # of module Mixin



# vim:ts=2:tw=100:wm=100:syntax=ruby
