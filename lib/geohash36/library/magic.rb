#!/usr/bin/env ruby


# System includes
require 'filemagic'


# @fn         class Magic
# @brief      Magic class takes a given image and determines its magic number and file type
class Magic

  # @fn       def initialize path, filename  {{{
  # @brief    
  #
  # @param    [String]        path
  # @param    [String]        filename
  def initialize path, filename 
    @path, @filename = path, filename
  end # }}}

  # @fn       def get path = @path, filename = @filename {{{
  # @brief    
  #
  # @param    [String]      path        
  # @param    [String]      filename    
  #
  # @returns  [String]      Containing the file type information
  def get path = @path, filename = @filename
    fq_path   = path + "/" + filename
    fm        = FileMagic.new

    fm.file( fq_path )
  end # }}}

end # of class magic


# Direct Invocation
if __FILE__ == $0
end # of if __FILE__ == $0

# vim:ts=2:tw=100:wm=100
