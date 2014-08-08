#!/usr/bin/env ruby


# System includes
require 'cgi'
require 'digest'


# @class        class Helpers
# @brief        Various helper functions which are useful everywhere
class Helpers

  # @fn         def initialize logger = nil # {{{
  # @brief      The constructor for the helpers class
  #
  # @param      [WowTech::Logger]   logger        Logger instance
  def initialize logger = nil

    # Input sanity check # {{{
    raise ArgumentError, "Logger can't be nil" if( logger.nil? )
    raise ArgumentError, "Logger must be of type WowTech::Logger" unless( logger.is_a?( WowTech::Logger ) )
    # }}}

    # Main
    @logger             = logger
    @digest             = Digest::SHA512.new
  end # }}}

  # @fn         def escaped? string # {{{
  # @brief      Checks if the string contains any unescaped 'special' characters and returns true if not, false if yes
  #
  # @param      [String]        string          String we want to check if it contains unescaped special characters
  # 
  # @returns    [Boolean]                       True, if the string contains only escaped or no special chars, false if not
  def escaped? string

    # Input verification # {{{
    raise ArgumentError, "String can't be nil" if( string.nil? )
    raise ArgumentError, "String must be of type string" unless( string.is_a?( String ) )
    # }}}

    # Main flow
    result = false

    # Only allowed characters in escaped sequence are ;, &, %

    # http://stackoverflow.com/questions/6343257/how-to-check-string-contains-special-character-in-ruby
    # removed "-" and "%" from the specials list
    # "-" doesn't get escaped actually and "%" is the indicator for the escape sequence
    special   = "?<>',?[]}{=)(*&^$#`~{}@" # escaped: "%3F%3C%3E%27%2C%3F%5B%5D%7D%7B%3D%29%28%2A%26%5E%25%24%23%60%7E%7B%7D%40"
    regex     = /[#{special.gsub(/./){|char| "\\#{char}"}}]/

    result = true unless( string =~ regex )

    return result
  end # }}}

  # @fn         def escape string # {{{
  # @brief      Takes a given string and makes sure it is safe for further usage. E.g. special characters are escaped etc.
  #
  # @param      [String]        string          String we want to sanitize
  # 
  # @returns    [String]                        Escaped result string
  def escape string

    # Input verification # {{{
    raise ArgumentError, "String can't be nil" if( string.nil? )
    raise ArgumentError, "String must be of type string" unless( string.is_a?( String ) )
    # }}}

    # Main flow
    result = nil

    if( escaped?( string ) )
      result = string                 # apparently this string is already properly escaped or it contains no dangerous characters
    else
      result = CGI.escape( string )   # needs sanitization
    end

    # Output check # {{{
    raise ArgumentError, "Output can't be nil" if( result.nil? )
    raise ArgumentError, "Output must be of type string" unless( result.is_a?( String ) )
    # }}}

    return result
  end # }}}

  # @fn         def unescape string # {{{
  # @brief      Takes a given escaped string and unescapes it to its original form
  #
  # @param      [String]        string          String we want to restore
  # 
  # @returns    [String]                        Unescaped result string
  def unescape string

    # Input verification # {{{
    raise ArgumentError, "String can't be nil" if( string.nil? )
    raise ArgumentError, "String must be of type string" unless( string.is_a?( String ) )
    # }}}

    # Main flow
    result = nil
    result = CGI.unescape( string )

    # Output check # {{{
    raise ArgumentError, "Output can't be nil" if( result.nil? )
    raise ArgumentError, "Output must be of type string" unless( result.is_a?( String ) )
    # }}}

    return result
  end # }}}

  # @fn         def get_random # {{{
  # @brief      The function returns a random hash generated from the systems urandom pseudo random device
  #
  # @returns    [String]                      String, containing the random hash
  def get_random
    random        = File.read( '/dev/urandom', 512 )
    hash          = hash( random ).to_s

    # Output sanity check # {{{
    raise ArgumentError, "Output must be at least 128 characters" unless( hash.length >= 128 )
    # }}}

    hash
  end # }}}

  # @fn         def hash string, digest = @digest # {{{
  # @brief      Takes a string object and returns a corresponding SHA hash according to the instantiated Digest
  #
  # @param      [String]      string        String which we want to hash
  # @param      [Digest]      digest        Instantiated digest which we will use for the hashing
  def hash string, digest = @digest

    # Input sanity check # {{{
    raise ArgumentError, "String cannot be nil" if( string.nil? )
    raise ArgumentError, "Digest cannot be nil" if( digest.nil? )
    raise ArgumentError, "String cannot be empty" if( string.empty? )
    raise ArgumentError, "Digest must be of type SHA512" unless( (digest.digest_length * 8) == 512 )
    # }}}

    # Main flow
    digest.reset
    result = digest.update( string ).to_s

    # Output sanity check # {{{
    raise ArgumentError, "Output must be of type string" unless( result.is_a?( String ) )
    raise ArgumentError, "Output must be not empty" if( result.empty? )
    raise ArgumentError, "Output must be at least 128 characters" unless( result.length >= 128 )
    # }}}

    result
  end # def hash string, digest = @digest # }}}

  # @fn         def snake_case str {{{
  # @brief      Receives a string and convert it to snake case. SnakeCase returns snake_case.
  #
  # @credit     https://github.com/erikhuda/thor/blob/master/lib/thor/util.rb
  def snake_case str
    return str.downcase if str =~ /^[A-Z_]+$/
    str.gsub(/\B[A-Z]/, '_\&').squeeze("_") =~ /_*(.*)/
    $+.downcase
  end # }}}

  # @fn         def camel_case str {{{
  # @brief      Receives a string and convert it to camel case. camel_case returns CamelCase.
  #
  # @credit     https://github.com/erikhuda/thor/blob/master/lib/thor/util.rb
  def camel_case str
    return str if str !~ /_/ && str =~ /[A-Z]+.*/
    str.split("_").map { |i| i.capitalize }.join
  end # }}}

end # of class Helpers


# = Direct Invocation testing
if __FILE__ == $0
end # of if __FILE__ == $0

# vim:ts=2:tw=100:wm=100
