#!/usr/bin/env ruby


# @module         module Scylla
# @brief          Scylla module namespace
module Scylla


  class ScyllaError < StandardError

    class << self
      # @param [Integer] code
      def status_code(code)
        define_method(:status_code) { code }
        define_singleton_method(:status_code) { code }
      end
    end

    alias_method :message, :to_s
  end # of class ScyllaError

  class DeprecatedError < ScyllaError; status_code(10); end
  class InternalError < ScyllaError; status_code(99); end
  class ArgumentError < InternalError; end
  class AbstractFunction < InternalError; end

  class ScyllafileNotFound < ScyllaError
    status_code(100)

    # @param [#to_s] filepath
    #   the path where a Scyllafile was not found
    def initialize(filepath)
      @filepath = File.dirname(File.expand_path(filepath)) rescue filepath
    end

    def to_s
      "No Scyllafile or Scyllafile.lock found at '#{@filepath}'!"
    end
  end

  class CookbookNotFound < ScyllaError
    status_code(103)

    def initialize(name, version, location)
      @name     = name
      @version  = version
      @location = location
    end

    def to_s
      if @version
        "Cookbook '#{@name}' (#{@version}) not found #{@location}!"
      else
        "Cookbook '#{@name}' not found #{@location}!"
      end
    end
  end

  class DuplicateDependencyDefined < ScyllaError
    status_code(105)

    def initialize(name)
      @name = name
    end

    def to_s
      out  = "Your Scyllafile contains multiple entries named "
      out << "'#{@name}'. Please remove duplicate dependencies, or put them in "
      out << "different groups."
      out
    end
  end

  class NoSolutionError < ScyllaError
    status_code(106)

    attr_reader :demands

    # @param [Array<Dependency>] demands
    def initialize(demands)
      @demands = demands
    end

    def to_s
      "Unable to find a solution for demands: #{demands.join(', ')}"
    end
  end

  class ScyllafileReadError < ScyllaError
    status_code(113)

    # @param [#status_code] original_error
    def initialize(original_error)
      @original_error  = original_error
      @error_message   = original_error.to_s
      @error_backtrace = original_error.backtrace
    end

    def status_code
      @original_error.respond_to?(:status_code) ? @original_error.status_code : 113
    end

    alias_method :original_backtrace, :backtrace
    def backtrace
      Array(@error_backtrace) + Array(original_backtrace)
    end

    def to_s
      [
        "An error occurred while reading the Scyllafile:",
        "",
        "  #{@error_message}",
      ].join("\n")
    end
  end


  class InvalidConfiguration < ScyllaError
    status_code(115)

    def initialize(errors)
      @errors = errors
    end

    def to_s
      out = "Invalid configuration:\n"
      @errors.each do |key, errors|
        errors.each do |error|
          out << "  #{key} #{error}\n"
        end
      end

      out.strip
    end
  end

  class InsufficientPrivledges < ScyllaError
    status_code(119)

    def initialize(path)
      @path = path
    end

    def to_s
      "You do not have permission to write to '#{@path}'! Please chown the " \
      "path to the current user, chmod the permissions to include the " \
      "user, or choose a different path."
    end
  end

  class DependencyNotFound < ScyllaError
    status_code(120)

    # @param [String, Array<String>] names
    #   the list of cookbook names that were not defined
    def initialize(names)
      @names = Array(names)
    end

    def to_s
      if @names.size == 1
        "Dependency '#{@names.first}' was not found. Please make sure it is " \
        "in your Scyllafile, and then run `berks install` to download and " \
        "install the missing dependencies."
      else
        out = "The following dependencies were not found:\n"
        @names.each do |name|
          out << "  * #{name}\n"
        end
        out << "\n"
        out << "Please make sure they are in your Scyllafile, and then run "
        out << "`berks install` to download and install the missing "
        out << "dependencies."
        out
      end
    end
  end


  class LockfileParserError < ScyllaError
    status_code(136)

    # @param [String] lockfile
    #   the path to the Lockfile
    # @param [~Exception] original
    #   the original exception class
    def initialize(original)
      @original = original
    end

    def to_s
      "Error reading the Scylla lockfile:\n\n" \
      "  #{@original.class}: #{@original.message}"
    end
  end

  class LockfileNotFound < ScyllaError
    status_code(140)

    def to_s
      'Lockfile not found! Run `berks install` to create the lockfile.'
    end
  end


  class LockfileOutOfSync < ScyllaError
    status_code(144)

    def to_s
      'The lockfile is out of sync! Run `berks install` to sync the lockfile.'
    end
  end


  class NoAPISourcesDefined < ScyllaError
    status_code(146)

    def to_s
      "Your Scyllafile does not define any API sources! You must define " \
      "at least one source in order to download cookbooks. To add the " \
      "default Scylla API server, add the following code to the top of " \
      "your Scyllafile:"
    end
  end

end

# vim:ts=2:tw=100:wm=100:syntax=ruby
