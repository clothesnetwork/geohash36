require 'aruba/cucumber'
require 'aruba/in_process'
require 'scylla/library/hypermedia/runner'


Aruba::InProcess.main_class = Scylla::Hypermedia::Runner
Aruba.process = Aruba::InProcess
