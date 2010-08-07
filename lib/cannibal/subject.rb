module Cannibal

  module Subject

    module ClassMethods

      def allow(actor, verb, attribute)
        permissions.allow_class(actor, verb, self)
      end

      def allow_obj(options)
        options[:subject] = self
        permissions.allow(options)
      end

      def deny(actor, verb, attribute)
        permissions.deny_class(actor, verb, self)
      end

      def permissions
        @registry ||= Cannibal::PermissionRegistry.instance
      end

    end
  
    def self.included(klass)
      klass.extend ClassMethods
    end

  end
end

