#!/usr/bin/env ruby


# @class  Server command class
# @brief  Implements the server command
class Version < Thor

  default_task :show

  ## API

  # @fn       def show {{{
  # @brief    Show version string of app
  desc 'show', 'Show version of this app'
  def show
    version = Scylla::VERSION

    puts version
  end # }}}


  private

  no_tasks do

    ## Actions

  end # of no_tasks do

end # of Class Version


# vim:ts=2:tw=100:wm=100:syntax=ruby
