#!/usr/bin/env ruby


# System libraries
require 'moneta'
require 'redis'
require 'hiredis'
require 'redis-objects'

# Serialization
require 'yaml'
require 'oj'
require 'ostruct'
require 'msgpack'

# Hashing
require 'digest/sha1'

# Lazy magic
# require 'lazy'
# require 'lazy/threadsafe'


# @class      class Cache 
# @brief      Cache control class
#
# @info       Some objects can't be serialized out of the box by messagepack alone. They throw
#             errors on attempt. In order to handle those cases we need to use e.g.
#             marshal+messagepack. This introduces a certain ambigiouty into the code which is
#             handled by some minimal guessing on our part. (e.g. given cache object how was it
#             serialized). Once msgpack can serialize any object we can skip this.
#
class Cache

  # @fn         def initialize logger # {{{
  # @brief      Constructor for cache class
  #
  # @param      [Logger]        logger        ClothesNetwork logger instance
  def initialize logger

    raise ArgumentError, "Logger can't be nil" if( logger.nil? )

    @redis        = Redis.new
    @logger       = logger
    @show         = false     # we turn off verbose logging entirely

    # If objects can't be serialized just by msgpack we use marshal+msgpack
    # In order to identify that quickly we encode this in the id string
    @prefixes     = [ "messagepack", "marshal_messagepack" ]

    # Dynamically construct helper query functions
    #
    # e.g. "def marshal_messagepack_exists?( key )" or "def messagepack_exists?( key )"
    # they leverage the "def exists?" func
    @prefixes.each do |prefix|
      name = prefix.to_s + "_exists?" # we use exists? fun to do actual lookup

      self.class.send( :define_method, name ) do |key, type = prefix|
        @logger.message :trace, "Inside #{name.to_s} with key (#{key.to_s})" if( @show )

        id        = construct_key type.to_s, key.to_s
        @logger.message :trace, "Constructed id: #{id.to_s}" if( @show )

        encoded   = encode_query( id )
        result    = exists?( encoded )

        return result
      end # of define_method
    end # of @prefixes.each

  end # def initialize }}}


  ### API

  # @fn         def lazy &computation # {{{
  # @brief      
  def lazy &computation

    object = nil

    begin
      # FIXME: Is there anyway to get a string of the command inside proc?
      proc_identifier     = computation.to_s # e.g. '#<Proc:0xcf77ba8@/home/br/....../src/routes/index.rb:14>'
      identifier          = proc_identifier.split( "@" ).last.to_s

      if( cached?( identifier ) )
        @logger.message :debug, "Found cached result for identifier (#{identifier.to_s})" if( @show )
        object            = retrieve( identifier )
      else
        @logger.message :debug, "No cached result for identifier (#{identifier.to_s})" if( @show )

        # Lazy eval the passed closure only
        # result = Lazy::Promise.new( &computation )

        object            = computation.call      # Resolve lazy
        stored            = store( identifier, object )  # save to db for next time
      end

    rescue Exception => e
      @logger.message :error, "Something went wrong with the caching internals, resolving without caching"
      p e

      object  = computation.call # resolve lazy (no benefit from caching)
    end

    return object
  end # }}}


  private

  ### High level interface

  # @fn         def store key, object {{{
  # @brief      Takes a complex object and a string key and stores that in redis
  #
  # @param      [String]      key       Input query string
  # @param      [Object]      object    FIXME
  # @param      [Numeric]     ttl       Time to live for this cache item in redis db
  #
  # @return     [Boolean]     Returns true if successful, false if not
  def store key, object, ttl = 60 * 5 # seconds

    raise ArgumentError, "Key cannot be nil" if( key.nil? )
    raise ArgumentError, "Object cannot be nil" if( object.nil? )
    raise ArgumentError, "ttl cannot be nil" if( ttl.nil? )

    result          = false

    begin
      prefix, serialized = *serialize( object )

      # Bail out, seems we didn't succeed doing serialization
      return result if( prefix.nil? || serialized.nil? )

      # Construct proper id and store
      tag           = construct_key prefix, key
      id            = encode_key( tag )
      result        = put( id, serialized, 5*60 )

      @logger.message :debug, "Stored data with encoded id (#{id.to_s}) key (#{tag.to_s})" if( @show )
    rescue Exception => e
      @logger.message :error, "Coudln't store data correctly - key (#{key.to_s})"
      p e
      result        = false
    end

    return result
  end # }}}

  # @fn         def retrieve identifier {{{
  # @brief      Retrieves cache item by given key from Database if it exists 
  #
  # @param      [String]      identify    Query input string
  #
  # @return     [Object or Nil]           Returns object or nil if not cached
  def retrieve identifier

    result  = nil

    begin
      raise ArgumentError, "Identifier cannot be nil" if( identifier.nil? )

      method, encoded_key   = *guess_key( identifier )

      return nil if( method.nil? || encoded_key.nil? ) # Bail out if there isn't anything in the cache

      data                  = get( encoded_key )
      result                = deserialize( data, method )

    rescue Exception => e
      result                = nil
      @logger.message :error, "Couldn't retrieve key (#{identifier.to_s})"
      p e
    end

    return result
  end # }}}


  ### Key Management

  # @fn         def guess_key identifier # {{{
  # @brief      Guesses the lookup key by running through possible prefixes+keys and checking in the db
  #
  # @param      [String]          identifier        Identifier
  #
  # @return     [Array]           Returns array containing method, key string which exists in db or empty
  def guess_key identifier

    key = []

    begin
      keys = get_possible_keys( identifier )

      keys.each_pair do |serialization_method, encoded|
        if( exists?( encoded ) )
          key << serialization_method
          key << encoded
          break
        end
      end

      raise ArgumentError, "Key array can only have two items" if( key.length > 2 )

    rescue Exception => e
      @logger.message :error, "Guess key failed for identifier (#{identifier.to_s})"
      p e
      key = []
    end

    return key

  end # }}}

  # @fn         def get_possible_keys identifier, prefixes = @prefixes # {{{
  # @brief      Constructs possible lookup keys since we need to guess what method we used to serialize
  #
  # @param      [String]        identifier        String representing a partial key, e.g. @/home/br/....../src/routes/index.rb:14>
  # @param      [Array]         prefixes          Defined prefixes for serialization methods from constructor, e.g. [ "messagepack", "marshal_messagepack" ]
  #
  # @return     [Hash]          Returns possible lookup keys for various serialization methods
  #
  # @info       FIXME: Once Msgpack is able to encode any object we can avoid all this marshal-msgpack mess
  #             FIXME: Use yaml only instead? dm-serialize? Benchmark
  def get_possible_keys identifier, prefixes = @prefixes

    result = Hash.new

    begin

      prefixes.each do |prefix| # e.g. "messagepack" 
        plain_key     = construct_key( prefix.to_s, identifier )
        encoded_key   = encode_key( plain_key )
        result[ prefix.to_s ] = encoded_key
      end

    rescue Exception => e
      result.clear
      @logger.message :error, "Couldn't contruct possible lookup keys"
      p e
    end

    return result

  end # }}}

  # @fn         def construct_key prefix, identifier # {{{
  # @brief      Construct lookup key from prefix and identifier (trivial)
  #
  # @param      [String]        prefix        Prefix, e.g. "messagepack"
  # @param      [String]        identifier    String representing a partial key, e.g. @/home/br/....../src/routes/index.rb:14>
  #
  # @return     [String]        Key string
  def construct_key prefix, identifier
    key = nil

    begin
      key = prefix.to_s + "_" + identifier.to_s
    rescue Exception => e
      @logger.message :error, "Couldn't construct key"
      p e
      key = nil
    end

    return key
  end # }}}

  # @fn         def encode_key string {{{
  # @brief      Takes a input string and returns a uniform lookup key for that value
  #
  # @param      [String]      string      Input query string (e.g. blue shoes)
  #
  # @return     [String]      Returns a hashes version of the input string
  def encode_key string, hash_method = :md5

    raise ArgumentError, "String cannot be nil" if( string.nil? )

    key       = ""

    case( hash_method )
      when :md5
        key = Digest::MD5.base64digest( string.to_s )
      when :sha1
        key = Digest::SHA1.base64digest( string.to_s )
      else
        raise NotImplementedError, "The requested hashing method is not implemented"
    end

    return key
  end # }}}


  ### Serializer helpers

  # @fn         def serialize object # {{{
  # @brief      Serializes given object with various strageties
  #
  # @param      [Object]      object      Object we want to serialize
  #
  # @return     [Array]       Returns array, first elemement is prefix for object, second element is serialized object string
  #                           Prefix is e.g. "marshal" or "marshal_messagepack" etc. (encodes what
  #                           strategy was used)
  def serialize object
    result  = []

    begin
      prefix        = "messagepack"
      serialized    = nil

      # Try to use msgpack serialization first, if it doesn't work use Ruby Marshal + Msgpack as last resort
      serialized    = messagepack( object )

      if( serialized.nil? )
        serialized  = marshal_messagepack( object )
        prefix      = "marshal_messagepack"
      end

      result        << prefix
      result        << serialized

      @logger.message :debug, "Successfully serialized object - strategy: (#{prefix.to_s})" if( @show )
    rescue Exception => e
      @logger.message :error, "Couldn't serialize given object"
      p e
      result.clear
    end

    return result
  end # }}}

  # @fn         def messagepack object # {{{
  # @brief      Takes object and tries to serialize it with MessagePack
  #
  # @param      [Object]          object        Some object you want to serialze
  #
  # @return     [String or Nil]   If successful returns String if not nil
  def messagepack object

    serialized    = nil

    begin
      serialized  = MessagePack.pack( object )
    rescue Exception => e
      serialized  = nil
    end

    return serialized
  end # }}}

  # @fn         def marshal_messagepack object # {{{
  # @brief      Takes object and tries to serialize it with Marshal+MessagePack
  #
  # @param      [Object]          object        Some object you want to serialze
  #
  # @return     [String or Nil]   If successful returns String if not nil
  def marshal_messagepack object

    serialized    = nil

    begin
      marshaled  = Marshal.dump( object )
      serialized  = MessagePack.pack( marshaled )
    rescue Exception => e
      serialized  = nil
    end

    return serialized
  end # }}}


  ### De-serializer helpers

  # @fn         def deserialize object, method = nil # {{{
  # @brief      Deerializes given object with various strageties
  #
  # @param      [String]      string      String we want to deserialize back into an Object
  # @param      [String]      method      Method to use for deserialization, if nil we guess
  #
  # @return     [Object or nil]           Returns deserialized object
  def deserialize object, method = nil

    deserialized    = nil

    begin

      if( method.nil? )

        # Try to use msgpack deserialization first, if it doesn't work use Ruby Marshal + Msgpack as last resort
        deserialized  = undo_messagepack( object )
        deserialized  = undo_marshal_messagepack( object )  if( deserialized.nil? )

      else

        deserialized  = undo_messagepack( object )          if( method == "messagepack" )
        deserialized  = undo_marshal_messagepack( object )  if( method == "marshal_messagepack" )

      end

      raise Exception, "Deserialization failed - different implementation? Database corruption?" if( deserialized.nil? )
    rescue Exception => e
      @logger.message :error, "Couldn't deserialize given object"
      p e
      deserialized    = nil
    end

    return deserialized
  end # }}}

  # @fn         def undo_messagepack object # {{{
  # @brief      Takes object and tries to deserialize it with MessagePack
  #
  # @param      [Object]          object        Some object you want to deserialze
  #
  # @return     [Object or nil]   If successful returns Object otherwise nil
  def undo_messagepack object

    deserialized      = nil

    begin
      deserialized    = MessagePack.unpack( object )
    rescue Exception => e
      deserialized    = nil
    end

    return deserialized
  end # }}}

  # @fn         def undo_marshal_messagepack object # {{{
  # @brief      Takes object and tries to deserialize it with Marshal+MessagePack
  #
  # @param      [Object]          object        Some object you want to deserialze
  #
  # @return     [Object or Nil]   If successful returns Object if not nil
  def undo_marshal_messagepack object

    result      = nil

    begin
      deserialized    = MessagePack.unpack( object )
      result          = Marshal.load( deserialized )
    rescue Exception => e
      result          = nil
    end

    return result
  end # }}}


  ### DB Key Value Store Helpers

  # @fn         def put key, data, ttl {{{
  # @brief      Takes given data and stores it with given key and ttl
  #
  # @param      [String]      key       Query input string
  # @param      [String]      data      Data string to store
  # @param      [Numeric]     ttl       Numerical value to use for ttl. If -1 or negative ttl is off
  #
  # @return     [Boolean]     Returns true if success, false if not
  def put key, data, ttl = 60 * 5 # 5 mins

    raise ArgumentError, "Key cannot be nil" if( key.nil? )
    raise ArgumentError, "Data cannot be nil" if( data.nil? )
    raise ArgumentError, "ttl cannot be nil" if( ttl.nil? )

    result    = false

    begin
      result  = @redis.set( key, data )
      @redis.expire( key, ttl ) unless( ttl < 0 )
      result  = true
    rescue Exception => e
      @logger.message :error, "Couldn't store data with key (#{key.to_s}) and TTL (#{ttl.to_s})"
      p e
      result  = false
    end

    return result
  end # }}}

  # @fn         def get key # {{{
  # @brief      Takes given lookup key and retrieves from key value store
  #
  # @param      [String]      key       Lookup key
  #
  # @return     [String or nil]         Returns string if success, nil if not
  def get key

    raise ArgumentError, "Key cannot be nil" if( key.nil? )

    result    = nil

    begin
      result  = @redis.get( key )
    rescue Exception => e
      @logger.message :error, "Couldn't get data with key (#{key.to_s})"
      p e
      result  = nil
    end

    return result
  end # }}}

  # @fn         def exists? key {{{
  # @brief      Checks if given key exists in redis db or not (general exist)
  #
  # @param      [String]      key       Query input string
  #
  # @return     [Boolean]     Returns true if it exists, false otherwise.
  def exists? key
    raise ArgumentError, "Key can't be nil" if( key.nil? )

    result = @redis.exists( key )

    return result
  end # }}}

  # @fn         def cached? indentifier # {{{
  # @brief      Checks given an identifier if we have a cached result or not
  #
  # @param      [String]        identifier        Identifier extracted from proc, e.g. @/home/br/....../src/routes/index.rb:14>'
  #
  # @return     [Boolean]       True if cached, false if not.
  def cached? identifier
    result = false

    begin
      array   = guess_key( identifier )
      result  = ( array.empty? ) ? false : true

      @logger.message :trace, "Guess key was (#{result.to_s}) for identifier (#{identifier.to_s})" if( @show )

    rescue Exception => e
      @logger.message :error, "Cached? function error, assuming cached? = false"
      p e
      result = false
    end

    return result
  end # }}}

end # of class Cache


# Direct Invocation
if __FILE__ == $0
end # of if __FILE__ == $0


# vim:ts=2:tw=100:wm=100
