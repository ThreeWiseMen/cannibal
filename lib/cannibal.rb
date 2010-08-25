require 'cannibal/actor'
require 'cannibal/subject'
require 'cannibal/configuration'

module Cannibal
  def self.configuration
    @configuration ||= Configuration.new
  end
end
