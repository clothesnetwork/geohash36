#!/usr/bin/env ruby


## Handle RSpec 1.x and 2.x branches # {{{
#
# dm-redis-adapter and others maybe need 1.x while we want 2.x is possible.
begin

  require 'rspec/core/rake_task'

  desc "RSpec Core Tasks" # {{{
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.rspec_opts = '--format NyanCatFormatter --color --fail-fast --order random'
  end # }}}

rescue LoadError

  puts "(WW) Could not load RSpec 2.x branch, falling back to 1.x."

  require 'spec/rake/spectask'

  desc "Run specs" # {{{
  Spec::Rake::SpecTask.new do |t|
    t.spec_files = FileList['spec/**/*_spec.rb']
    t.spec_opts = %w(-fs --color)
  end # }}}

end # }}}


# vim:ts=2:tw=100:wm=100:syntax=ruby
