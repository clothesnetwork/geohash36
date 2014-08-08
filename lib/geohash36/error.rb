#!/usr/bin/env ruby


Dir[ "#{File.dirname(__FILE__)}/error/*.rb" ].sort.each do |path|
  require_relative "error/#{File.basename( path, '.rb' )}"
end

# vim:ts=2:tw=100:wm=100:syntax=ruby
