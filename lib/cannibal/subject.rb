module Cannibal

  module Subject
    module ClassMethods
      def allow(actor, verb)
        method_name = "can_#{actor.to_s.downcase}_#{verb}?"
        method_body = Proc.new { instance_eval { true } }
        define_method(method_name, method_body)
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end
  end

end
