module Cannibal

  module Subject

    module ClassMethods

      def allow(actor, verb, attribute)
        permissions.allow(actor, verb, self)
      end

      def deny(actor, verb, attribute)
        permissions.deny(actor, verb, self)
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

