module Cannibal

  module Actor
    module ClassMethods
    end

    def self.included(base)
      base.extend(ClassMethods)
    end
  end

end
