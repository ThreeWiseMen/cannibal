lib_dir = File.dirname(__FILE__) + '/../../lib'

$:.unshift lib_dir unless $:.include?(lib_dir)

require 'rspec/expectations'

require 'cannibal'
