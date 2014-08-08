#!/usr/bin/env ruby


Dir[ "#{File.dirname(__FILE__)}/core_ext/*.rb" ].sort.each do |path|
  require_relative "core_ext/#{File.basename( path, '.rb' )}"
end

# vim:ts=2:tw=100:wm=100:syntax=ruby
