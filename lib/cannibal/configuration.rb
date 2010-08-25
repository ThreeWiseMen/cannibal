module Cannibal
  class Configuration
    DEFAULT_OPTIMISM = false

    def initialize
      @optimism = DEFAULT_OPTIMISM
    end

    def optimistic?
      @optimism
    end

    def pessimistic!
      @optimism = false
    end

    def optimistic!
      @optimism = true
    end
  end
end
