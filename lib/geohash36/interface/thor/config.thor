#!/usr/bin/env ruby


# System includes
require 'fileutils'

#Custom includes
require File.expand_path( File.dirname( __FILE__ ) + '/mixin/default_config' )

# @fn     class Generate < Thor
# @brief  Generate config files
class Config < Thor

  # Include various partials
  include Thor::Actions
  include ::Mixin::DefaultConfig


  desc "generate", "Generate scylla config file" # {{{

  option :url,      desc: "Jason url"
  option :ip,       desc: "Jason ip"
  option :port,     desc: "Jason port"
  option :username, desc: "Jason username"
  option :password, desc: "Jason password"
  option :token,    desc: "Jason token"

  def generate
    template_path = Thor::Sandbox::Config.source_root(File.expand_path( File.dirname( __FILE__ ) + '/../../template/config.tt'))
    config        = defaults['jason'].merge(options)
    template(template_path, File.expand_path( '~/.scylla/config.yml' ), config)
  end # }}}

  desc "clean", "Removes scylla config file" # {{{
  def clean
    config_path = File.expand_path( '~/.scylla/config.yml' )
    File.delete(config_path) if( File.exist?(config_path) )
  end # }}}

end # of class Generate < Thor

# vim:ts=2:tw=100:syntax=ruby
