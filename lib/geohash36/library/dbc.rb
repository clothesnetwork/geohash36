#!/usr/bin/env ruby


# @module       module DBC # {{{
# @brief        Handles Design by Contract feature in ruby
#
# @credit       Inspired by http://dev.theconversation.edu.au/post/5408538899
module DBC

  # New classes
  module Boolean; end
  class TrueClass;  include Boolean; end
  class FalseClass; include Boolean; end

  class DBCError < RuntimeError
    attr_accessor :name, :message, :description, :caller, :url
  end

  class PreconditionError                   < DBCError; end
  class AssertconditionError                < DBCError; end
  class PostconditionError                  < DBCError; end
  class FailError                           < DBCError; end

  class CannotBeNilError                    < DBCError; end
  class TypeMismatchError                   < DBCError; end
  class CannotBeEmptyError                  < DBCError; end
  class DoesNotRespondToMethodCallError     < DBCError; end
  class ShouldBeGreaterThanError            < DBCError; end
  class ShouldBeGreaterThanOrEqualError     < DBCError; end
  class ShouldBeLessThanError               < DBCError; end
  class ShouldBeLessThanOrEqualError        < DBCError; end
  class ShouldBeExactlyEqualError           < DBCError; end
  class ValidCharsMismatchError             < DBCError; end
  class IllegalParametersError              < DBCError; end
  class WrongUsernameError                  < DBCError; end

  #### Higher Level DbC

  def self.define_new_error_class  name
    eval( "class DBC::#{name.to_s} < DBC::DBCError; end" )
    @@throws_this_error = eval(name)
  end

  @@throws_this_error = nil


  # def self.raise_error( error_class, description )
  #  self.instance_eval( "class #{error_class.to_s} < RuntimeError; end" ) unless( Object.const_defined?( error_class.to_s ) )   # Throws your own custom error class as defined in throws from the caller
  #  error( error_class, description.to_s, description.to_s, caller )
  # end


  # @fn         def self.must_be test_object, expected_type, *conditions # {{{
  # @brief      Checks the test_object if it matches the expected_type and is non nil, plus all other *conditions required.
  #             Delegates the tests to subfunctions tests
  #
  # @param      [Object]        test_object         The intantiated test object or primitive we want to check
  # @param      [Object]        expected_types      Type of the class of object we expect, or an array containing multiple types we accept
  # @param      [Array]         conditions          Array of arbitary amount of arguments we need to verify
  def self.must_be( test_object, description, expected_types, *conditions )

    # Make sure we define custom error classes as supplied by throw, so that we later don't get a unitialized constant error
    conditions.each do |condition|
      if( condition.class.to_s == "Hash" )
        condition.each_pair do |key, value|
          if( key == :throws )
            define_new_error_class value
          end
        end
      end
    end


    # Make sure its not nil
    error( CannotBeNilError, "Argument cannot be nil", description, caller ) if( test_object.nil? )

    # Make sure its one of the expected_types
    if( expected_types.is_a?( Array ) )
      # Iterate over all given types and determine if one of it is true, if not we have an error
      match = []
      expected_types.each { |type| match << ( test_object.is_a?( type ) ) ? ( true ) : ( false ) }

      error( TypeMismatchError, "Object must be one of the types (#{expected_types.join(", ").to_s}) but was (#{test_object.class})", description, caller ) unless( match.include?( true ) )
    else
      error( TypeMismatchError, "Object must be of type (#{expected_types.to_s}) but was (#{test_object.class})", description, caller ) unless( test_object.is_a?( expected_types ) )
    end

    # Check that all conditions are met
    conditions.each do |condition|

      case condition.class.to_s
        when "Symbol"
          if( condition == :not_empty )
            error( CannotBeEmptyError, "Cannot be empty", description, caller ) if( empty?( test_object ) )
          else
            error( NotImplementedError, "Don't know how to handle this condition.", description, caller )
          end
        when "Hash"
          condition.each_pair do |key, value|
            case key
              when :responds_to
                error( DoesNotRespondToMethodCallError, "Doesn't respond to method call", description, caller ) unless( test_object.respond_to?( value ) )
              when :gt
                to = test_object
                to = test_object.length if( test_object.is_a?( String ) )
                error( ShouldBeGreaterThanError, "Should be greater than (#{value.to_s}) but was (#{to.to_s})", description, caller ) unless( to > value )
              when :gt_eq
                to = test_object
                to = test_object.length if( test_object.is_a?( String ) )
                error( ShouldBeGreaterThanOrEqualError, "Should be greater than or equal to (#{value.to_s}) but was (#{to.to_s})", description, caller ) unless( to >= value )
              when :lt
                to = test_object
                to = test_object.length if( test_object.is_a?( String ) )
                error( ShouldBeLessThanError, "Should be less than (#{value.to_s}) but was (#{to.to_s})", description, caller ) unless( to < value )
              when :lt_eq
                to = test_object
                to = test_object.length if( test_object.is_a?( String ) )
                error( ShouldBeLessThanOrEqualError, "Should be less than or equal to (#{value.to_s}) but was (#{to.to_s})", description, caller ) unless( to <= value )
              when :eq
                to = test_object
                to = test_object.length if( test_object.is_a?( String ) )
                error( ShouldBeExactlyEqualError, "Should be exactly equal to (#{value.to_s}) but was (#{to.to_s})", description, caller ) unless( to == value )
              when :valid_chars
                if( test_object.is_a?( String ) )
                  check = test_object
                  error( ValidCharsMismatchError, "There are characters which are not allowed in the string, only allowed chars are (#{value.to_s})", description, caller ) unless( (check.tr( value, "" )).empty? )
                else
                  error( NotImplementedError, "Don't know how to handle this condition.", description, caller )
                end
              when :throws
                self.instance_eval( "class #{value.to_s} < RuntimeError; end" ) unless( Object.const_defined?( value.to_s ) )   # Throws your own custom error class as defined in throws from the caller
              when :only_contains
                  check = test_object
                  value.each { |v| check.delete_if { |c| c == v } }
                  error( IllegalParametersError, "There are parameters given which are not allowed", description, caller ) unless( check.empty? )
              else
                error( NotImplementedError, "Don't know how to handle this condition.", description, caller )
            end
          end
        else
          error( NotImplementedError, "Don't know how to handle this condition.", description, caller )
      end # of condition.class

    end # of condition.each do

  end # of def self.must_be test_object, expected_type, *conditions # }}}


  # @fn           def self.describe *args, &block_group # {{{
  # @brief        The function describe provides a simple DSL to describe if the conditions provided are pre or post conditions
  #
  # @param        [Array]         args            Array, containing an arbitrary length of arguments given to the describe function.
  # @pram         [Proc]          block_group     Proc, containing the block given to describe
  def self.describe *args, &block_group

    raise ArgumentError, "Currently we only expect one argument for the describe" if( args.length > 1 )
    argument    = args.first

    case argument
      when "Precondition"
        self.instance_eval( &block_group )    # Execute the proc in the local context of the DBC module
      when "Postcondition"
        self.instance_eval( &block_group )
      when "Intercondition"
        self.instance_eval( &block_group )
      else
        raise ArgumentError, "Don't know what to do with #{args.join(", ")}"
    end

  end # of def self.describe *args, &block_group # }}}


  # @fn           def self.empty? test_object # {{{
  # @brief        Checks if a provided object is empty. If it is returns true, otherwise false.
  #
  # @param        [Object]        test_object         Object we want to test
  #
  # @returns      True, if empty, false if not
  def self.empty? test_object = nil

    error( NotImplementedError, "Object cannot be nil, don't know what to do", "", caller ) if( test_object.nil? )

    empty = nil

    case test_object.class.to_s
      when "OpenStruct"
        empty = test_object.instance_variable_get("@table").empty?
      when "String"
        empty = test_object.empty?
      when "Hash"
        empty = test_object.empty?
      else
        puts "test_object.class is #{test_object.class.to_s}"
        error( NotImplementedError, "Don't know how to handle this condition. (test_object.class is #{test_object.class.to_s})", "",  caller )
    end

    error( NotImplementedError, "Don't know how to handle this condition.", description, caller ) if( empty.nil? )

    empty
  end # }}}



  #### Lower Level DBC

  def self.require(condition, message = "")
    unless condition
      error( PreconditionError, message, "", caller )
    end
  end

  def self.assert(condition, message = "")
    unless condition
      error( AssertconditionError, message, "", caller )
    end
  end

  def self.ensure(condition, message = "")
    unless condition
      error( PostconditionError, message, "", caller )
    end
  end

  def self.fail( message = "" )
    error( FailError, message, "", caller )
  end

  private

  def self.error( klass, message, description, caller )

    # raise klass.new("#{klass.name} condition failed: #{message}\nTrace was: #{caller.join("\n")}")  if( show_trace )

    # REALLY Messy
    unless( @@throws_this_error.nil? )
      klass = @@throws_this_error
      @@throws_this_error = nil
    end

    if( klass.methods.include?( :name ) )
      error               = klass.new( "#{klass.name}" )
      error.name          = klass.name
      error.message       = message           
      error.description   = description 
      error.caller        = caller
      error.url           = ""

      raise error
    else
      raise klass
    end
  end

end # }}}

# module PRE include DBC ; end


# Direct Invocation
if __FILE__ == $0 # {{{
end # of if __FILE__ == $0 # }}}

# vim:ts=2:tw=100:wm=100
