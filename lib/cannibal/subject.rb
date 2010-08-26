require 'cannibal/helpers'

module Cannibal

  module Subject
    include Cannibal::Helpers

    module ClassMethods
      def allow(actor, action, attribute = nil, &block)
        actor_class = actor.name
        method_name = Cannibal::Helpers.can_method_name(actor_class, action, attribute)
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
