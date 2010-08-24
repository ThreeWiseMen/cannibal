module Cannibal

  module Subject
    module ClassMethods
      def allow(actor, verb, &block)
        method_name = "can_#{actor.to_s.downcase}_#{verb}?"
        if block_given?
          method_body = Proc.new { |obj| instance_exec { block.call(obj) } }
        else
          method_body = Proc.new { true }
        end
        define_method(method_name, method_body)
      end
    end

    def self.included(base)
      base.extend(ClassMethods)
    end
  end

end
