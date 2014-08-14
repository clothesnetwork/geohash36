#!/usr/bin/env ruby

namespace :metric do

  desc "Run metric fu for project" # {{{
  task :metric do |t|
    puts "(--) Running metric fu"
    system "metric_fu"
  end # }}}

end # of namespace :metric

# vim:ts=2:tw=100:wm=100:syntax=ruby
