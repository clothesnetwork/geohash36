#!/usr/bin/env ruby


## Handle Cucumber # {{{

namespace :cucumber do

  begin
    require 'cucumber'
    require 'cucumber/rake/task'

    desc "Cucumber Core Tasks" # {{{
    Cucumber::Rake::Task.new(:pretty) do |t|
      t.cucumber_opts = "--format pretty -S"
    end # }}}

    desc "Cucumber Core Tasks" # {{{
    Cucumber::Rake::Task.new(:progress) do |t|
      t.cucumber_opts = "--format progress -S"
    end # }}}

  rescue LoadError
    desc 'Cucumber rake task not available'
    task :pretty do
      abort 'Cucumber rake task is not available. Be sure to install cucumber as a gem or plugin'
    end

    task :progress do
      abort 'Cucumber rake task is not available. Be sure to install cucumber as a gem or plugin'
    end
  end

end # pf namespace }}}


# vim:ts=2:tw=100:wm=100:syntax=ruby
