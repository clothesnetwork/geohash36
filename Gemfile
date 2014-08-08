# File: Gemfile


# Sources to draw gems from
source "https://rubygems.org"
# source 'http://gems.rubyforge.org'
# source 'http://gemcutter.org'


# Depend on a certain ruby version
ruby '2.1.2'


group :production do # {{{

  ########
  #
  # Do not add production gems here, but instead use
  # geohash36.gemspec file !
  #
  ####

end # }}}

group :default do # {{{

  # System
  gem 'bundler'
  gem 'rake'

  gem 'moneta'
  gem 'redis'

end # }}}

group :development do # {{{

  # Generate manuals
  gem 'ronn', '<= 0.7.2'
  gem 'rdiscount'

  # REPL
  gem 'racksh'
  gem 'pry'

  platforms :ruby_19, :ruby_20 do
    gem 'pry-debugger'
    gem 'pry-stack_explorer'
  end

  gem 'lorem'

  # Re-loads app after every request
  gem 'shotgun'
  gem 'rerun'

  gem 'guard'
  gem 'guard-shell'

  # Notifications from live-reload etc.
  gem 'growl'
  gem 'ruby-growl'
  gem 'rb-inotify' unless RUBY_PLATFORM=~ /darwin/

end # }}}

group :test do # {{{

  # Testing / Development
  gem 'aruba'
  gem 'rspec', '~> 2.0'
  gem 'guard-rspec', require: false
  gem 'nyan-cat-formatter'
  gem 'simplecov', '~> 0.8.1'
  gem 'simplecov-rcov'
  gem 'simplecov-rcov-text'
  gem 'metric_fu', '>= 4.5.x'

  # gem 'dm-sweatshop'
  gem 'randexp' # used by dm-sweatshop

  gem 'cucumber'
  gem 'capybara'

end # }}}

group :security do # {{{

  # 0-days?
  gem 'bundler-audit'

  # Secure credentials
  gem 'secure_yaml'

end # }}}

group :profiling do # {{{

  gem 'stackprof'

end # }}}

group :docs do # {{{

  gem 'yumlcmd'
  gem 'coderay' # syntax highlighting and code formatting in html
  gem 'redcarpet'
  gem 'github-markup'

  gem 'htmlentities'

  gem 'dm-visualizer', require: false

  # gem 'gollum'

  # Documentation
  gem 'yard'
  gem 'wicked_pdf'
  gem 'wkhtmltopdf'

end # }}}


# Declare geohash36.gemspec
gemspec



# vim:ts=2:tw=100:wm=100
