# File: Guardfile


# System include
require 'tempfile'


guard :shell, :all_on_start => false do

  # @fn         watch( %r{lib/.+\.(rb)$} ) do |m| # {{{
  # @brief      Run metric fu on each file change
  watch( %r{lib/.+\.(rb)$} ) do |m|

    # Manually throttle how often we call metric fu
    @counter.inc
    if( @counter.execute? )
      puts "(--) #{m[0].to_s} has changed re-running metric-fu"
      # %x{rake metric}       # shows NO STDOUT
      system "rake metric"    # shows STDOUT
      puts "(--) Finished metric fu run"
    else
      STDOUT.puts "(--) Current skip counter tells us we shouldn't execute metric fu"
    end
  end # of watch( %r{src/.+\.(rb)$} ) do |m| # }}}

end # of guard :shell, :all_on_start => false do


guard :rspec, cmd: 'bundle exec rspec' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/geohash36/(.+)\.rb$})     { |m| "spec/#{m[1]}_spec.rb" }
  watch('lib/geohash36.rb')     { 'spec' }
  watch('spec/spec_helper.rb')  { 'spec' }
end

guard 'rake', :task => 'docs:generate' do
  watch(%r{^lib/geohash36/(.+)\.rb$})
  watch('lib/geohash36.rb')
end

### Simple Helpers


# @class        class Counter
# @brief        Simple module to create a counter to trottle guard shell
class Counter

  # @fn         def initialize # {{{
  # @brief      Default constructor for Counter class
  #
  # @param      [Integer]     execute_on_mod        Execute on modulo n of counter
  def initialize execute_on_mod = 3
    @file            = Tempfile.new( "guard-shell" )
    @path            = @file.path
    @execute_on_mod  = execute_on_mod.to_i

    puts "(--) Running execute on every #{execute_on_mod.to_s}"
    puts "(--) Storing skip counter in #{@path.to_s}"

  end # }}}

  # @fn         def get filename = @path # {{{
  # @brief      Get counter from dumpfile
  #
  # @param      [String]      filename        Filename string
  #
  # @return     [Integer]     Returns integer counter
  def get filename = @path

    # Get current counter from file
    current   = File.open( filename, "r" ).read.strip.to_s
    counter   = current.tr( "^0-9", "" )

    # Sanity check
    counter   = 0 if( counter == "" )
    counter   = counter.to_i if( counter.is_a?( String ) )

    return counter
  end # }}}

  # @fn         def put counter, filename = @path # {{{
  # @brief      Put counter to dumpfile
  #
  # @param      [Integer]     counter         Counter
  # @param      [String]      filename        Filename string
  def put counter, filename = @path
    File.write( filename.to_s, counter )
  end # }}}

  # @fn         def inc filename = @path # {{{
  # @brief      Increment counter on file
  #
  # @param      [String]      filename        Filename string
  def inc filename = @path

    counter   =   get
    counter   +=  1
    put( counter )

  end # }}}

  # @fn         def execute? # {{{
  # @brief      Boolean switch if counter is modulo the trigger index
  #
  # @return     [Integer]     mod             Modulo trigger number
  # @param      [String]      filename        Filename string
  #
  # @return     [Boolean]     Returns true, if mod of trigger index from contstructor is correct, false if not.
  def execute? mod = @execute_on_mod
    counter = get
    result  = false
    result  = true  if( (counter % mod) == 0  )

    return result
  end # }}}

end # of class Counter

@counter = Counter.new( 3 )


# vim:ts=2:tw=100:wm=100:syntax=ruby

