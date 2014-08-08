require 'aruba/cucumber'
require 'aruba/in_process'
require 'geohash36/library/hypermedia/runner'


Aruba::InProcess.main_class = Geohash36::Hypermedia::Runner
Aruba.process = Aruba::InProcess
