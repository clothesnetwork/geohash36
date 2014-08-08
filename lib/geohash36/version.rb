#!/usr/bin/env ruby


# @module   Scylla Module
# @brief    Implements the Scylla module wrapper around the Scylla API
module Scylla

  VERSION = `git describe --tags`.split("-").first || "0.1.0"

end

# vim:ts=2:tw=100:wm=100:syntax=ruby
