module Cannibal
  module Helpers
    def self.can_method_name(actor, action, attribute = nil)
      actor_name = actor.downcase
      action_name = action.to_s
      method_name = "can_#{actor_name}_#{action_name}"
      if attribute
        attr_name = attribute.to_s
        method_name << "_#{attr_name}"
      end
      method_name << "?"
    end
  end
end
