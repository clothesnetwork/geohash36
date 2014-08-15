#!/usr/bin/env ruby


namespace :docs do

  desc "Generate Yardoc documentation for this project" # {{{
  task :generate do |t|

    # Define new tags for yardoc to detect
    tags             = {}
    tags[ "module" ] = "Module"
    tags[ "class" ]  = "Class"
    tags[ "fn" ]     = "Function"
    tags[ "brief" ]  = "Description"

    # Hide tags we don't want in yardoc output
    hidden           = %w[module class fn]
    files = %w|lib/*.rb lib/**/*.rb lib/**/**/*.rb - COPYING.md AUTHORS.md|.join " "

    # Construct tag string for CLI command
    tags_line = ""
    tags.each_pair { |n,v| tags_line += " --tag #{n.to_s}:\"#{v.to_s}\"" }
    hidden.each { |h| tags_line += " --hide-tag #{h.to_s}" }

    puts "(II) Generating multi-file yardoc output written to doc/yardoc"
    system "yard --markup-provider=redcarpet --markup=markdown #{tags_line.to_s} -o doc/yardoc #{files}"

    puts "(II) Generating one-file yardoc output written to doc/yardoc_pdf"
    system "yard --markup-provider=redcarpet --markup=markdown --one-file #{tags_line.to_s} -o doc/yardoc_pdf #{files}"

    # puts "(II) HTML to PDF written to doc/yardoc_pdf"
    # pdf = WickedPdf.new.pdf_from_string( File.read( "doc/yardoc_pdf/index.html" ) )
    # File.write( "doc/yardoc_pdf/index.pdf", pdf )
  end # }}}

  desc "Generate Yard Graphs for this project" # {{{
  task :graph do |t|
    basedir = "doc/yard-graph"
    FileUtils.mkdir_p( basedir )
    system "yard graph --dependencies --empty-mixins --full > #{basedir.to_s}/graph.dot"
    system "dot -Tpng #{basedir.to_s}/graph.dot > #{basedir.to_s}/graph.png"
  end # }}}

end # of namespace :docs

# vim:ts=2:tw=100:wm=100:syntax=ruby
