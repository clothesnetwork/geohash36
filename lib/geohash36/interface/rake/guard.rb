#!/usr/bin/env ruby


namespace :guard do

  desc "Execute Ruby Guard" # {{{
  task :default do |g|
    sh "bundle exec guard start -G Guardfile"
  end # }}}

end

# vim:ts=2:tw=100:wm=100:syntax=ruby
