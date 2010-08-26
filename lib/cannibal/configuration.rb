module Cannibal
  class Configuration
    DEFAULT_OPTIMISM = false

    def initialize
      default_optimism!
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

    def default_optimism!
      @optimism = DEFAULT_OPTIMISM
    end
  end
end
