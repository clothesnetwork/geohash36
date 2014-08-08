#!/usr/bin/env ruby


# System include
require 'benchmark'


namespace :measurement do

  desc 'When executing rake tasks measure elapsed time, used with other tasks' # {{{
  task :benchmark do

    # @module           module Rake
    # @brief            Rake commandline scripting tool
    module Rake

      # @class          class Task
      # @brief          Rake Task class for individual executions of logical blocks
      class Task

        alias_method :real_invoke, :invoke

        # @fn           def invoke *args {{{
        # @brief        Benchmark task execution of rake tasks
        #
        # @param        [Array]       args        Array of provided rake arguments
        def invoke *args

          time = Benchmark.measure( @name ) do
            real_invoke *args
          end

          puts ""
          puts "=> '#{@name}' ran for #{time}"
        end # }}}

      end # of class Task

    end # of module Rake

  end # of of task :benchmark # }}} 

  desc 'Run profiling over stack' # {{{
  task :profiling do
    sh "stackprof src/tmp/stackprof-cpu-*.dump --text"
  end # }}}

end # of namespace :measurement


# vim:ts=2:tw=100:wm=100:syntax=ruby
