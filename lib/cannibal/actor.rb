require 'cannibal/helpers'

module Cannibal

  module Actor
    include Cannibal::Helpers
    def can?(action, subject, attribute = nil)
      class_name = self.class.name
      method_name = Cannibal::Helpers.can_method_name(class_name, action, attribute)
      if subject.respond_to?(method_name)
        subject.send(method_name, self)
      else
        Cannibal.configuration.optimistic?
      end
    end
  end

end
