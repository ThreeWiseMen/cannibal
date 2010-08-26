require 'cannibal/actor'
require 'cannibal/configuration'
require 'cannibal/helpers'
require 'cannibal/subject'

module Cannibal
  def self.configuration
    @configuration ||= Configuration.new
  end
end
