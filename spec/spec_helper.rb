lib_dir = File.dirname(__FILE__) + '/../lib'

require 'rspec'
$:.unshift lib_dir unless $:.include?(lib_dir)

require 'cannibal'

RSpec.configure do |config|
  config.mock_with :rspec
end
