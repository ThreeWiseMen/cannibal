require 'rspec'

lib_dir = File.dirname(__FILE__) + '/../lib'

$:.unshift lib_dir unless $:.include?(lib_dir)

RSpec.configure do |config|
  config.mock_with :rspec
end
