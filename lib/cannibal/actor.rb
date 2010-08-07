module Cannibal
  module Actor

    module ClassMethods
      def can?(verb, subject, attribute=nil)
        permissions.allowed?(self, subject, verb, attribute)
      end

      def permissions
        @@registry = Cannibal::PermissionRegistry.instance
      end
    end

    def self.included(klass)
      klass.extend ClassMethods
    end

    def can?(verb, subject, attribute=nil)
      self.class.permissions.allowed?(self, subject, verb, attribute)
    end

  end
end

