# File: geohash36.gemspec

# Make sure lib is in Load path
lib = File.expand_path( '../lib/', __FILE__ )
$LOAD_PATH.unshift lib unless $LOAD_PATH.include?( lib )

# System includes
require 'date'

# Custom includes
require 'geohash36/version'

Gem::Specification.new do |spec|

  spec.name                 = 'geohash36'

  spec.description          = %q(Commandline interface and library to the Geohash36 Algorithm)
  spec.summary              = spec.description

  spec.authors              = [ 'Bjoern Rennhak', 'Oleg Orlov' ]
  spec.email                = [ 'bjoern@clothesnetwork.com', 'orelcokolov@gmail.com' ]

  spec.homepage             = 'http://github.com/clothesnetwork/geohash36'

  spec.licenses             = %w[MIT]

  spec.date                 = DateTime.now.to_s.split( 'T' ).first
  spec.version              = Geohash36::VERSION
  spec.platform             = Gem::Platform::RUBY

  spec.metadata             = {
                                "issue_tracker" =>  "http://github.com/clothesnetwork/geohash36"
                              }

  spec.bindir               = 'bin'
  spec.executables          = %w[geohash36]

  spec.require_paths        = %w[lib]

  spec.files                = %w[
                                  AUTHORS.md
                                  CHANGELOG.md
                                  COPYING.md
                                  LICENSE.md
                                  MAINTAINERS.md
                                  Gemfile
                                  README.md
                                  Rakefile
                                  Thorfile
                                  geohash36.gemspec
                                ]

  spec.files                += Dir.glob( 'bin/**/*' )

  spec.files                += Dir.glob( 'lib/**/*.rb' )
  spec.files                += Dir.glob( 'lib/**/*.thor' )

  spec.files                += Dir.glob( 'spec/**/*' )

  spec.files                += Dir.glob( 'thrift/**/*' )

  spec.files                += Dir.glob( 'data/**/*' )

  spec.files                += Dir.glob( 'documentation/**/*' )

  spec.files                += Dir.glob( 'examples/**/*' )

  spec.files                += Dir.glob( 'base/**/*' )

  spec.test_files           += Dir.glob( 'test/**/*' )
  spec.test_files           += Dir.glob( 'spec/**/*' )
  spec.test_files           += Dir.glob( 'features/**/*' )

  ## Dependencies

  # Ruby VM
  spec.required_ruby_version  = '~> 2.1'

  # General
  spec.add_runtime_dependency 'thor'
  spec.add_runtime_dependency 'ruby-try', '~> 1.1.1'

  # Package building
  spec.add_runtime_dependency 'fpm'

  # Shell
  spec.add_runtime_dependency 'ptools'
  spec.add_runtime_dependency 'os'

  # Database (Volatile)
  spec.add_runtime_dependency 'redis'
  spec.add_runtime_dependency 'hiredis'
  spec.add_runtime_dependency 'redis-objects'

  # Data RPCs and Messaging
  spec.add_runtime_dependency 'msgpack'
  # spec.add_runtime_dependency 'xmpp4r'
  # spec.add_runtime_dependency 'xmpp4r-simple' # , :git => 'git://github.com/blaine/xmpp4r-simple.git'
  spec.add_runtime_dependency 'amqp'

  spec.add_runtime_dependency 'faraday'
  spec.add_runtime_dependency 'mime-types'

  # Data Exchange Containers/Parsing
  spec.add_runtime_dependency 'oj'
  spec.add_runtime_dependency 'ox'
  spec.add_runtime_dependency 'nokogiri'
  spec.add_runtime_dependency 'hpricot'
  spec.add_runtime_dependency 'cobravsmongoose'

  # Caching
  spec.add_runtime_dependency 'moneta'

  # Mail
  spec.add_runtime_dependency 'pony'

  # l10n
  spec.add_runtime_dependency 'gettext'

  # Rest interface
  spec.add_runtime_dependency 'rack'

  # Monadic/Functional
  spec.add_runtime_dependency 'andand'
  spec.add_runtime_dependency 'ick'

  # Misc System
  spec.add_runtime_dependency 'awesome_print'
  spec.add_runtime_dependency 'uuid'

  ## System libraries needed (info for the user)
  # spec.requirements 'iconv zlib libmagic'

  # spec.requirements 'redis-server'
  # spec.requirements 'sqlite3 libsqlite3-dev'


  ## Post Install
  spec.post_install_message = <<-EOS
      ____ _____ ___  _   _    _    ____  _   _ _____  __
     / ___| ____/ _ \| | | |  / \  / ___|| | | |___ / / /_
    | |  _|  _|| | | | |_| | / _ \ \___ \| |_| | |_ \| '_ \
    | |_| | |__| |_| |  _  |/ ___ \ ___) |  _  |___) | (_) |
     \____|_____\___/|_| |_/_/   \_\____/|_| |_|____/ \___/

    (c) #{spec.date.to_s}, All rights reserved
    Clothes Network Ltd., Bjoern Rennhak

    Don't forget to configure $HOME/.geohash36/config.
    To generate config file under $HOME/.geohash36/ directory,
    please run 'geohash36 config:generate' command

    Thanks for installing Geohash36 !
  EOS

end # of Gem::Specification.new do |s|


# vim:ts=2:tw=100:wm=100:syntax=ruby
