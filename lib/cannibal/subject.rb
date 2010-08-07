module Cannibal

  module Subject

    module ClassMethods

      def allow(actor, verb, attribute=nil)
        permissions.set(
          :actor => actor,
          :verb => verb,
          :subject => self,
          :perm => true
        )
      end

      def deny(actor, verb, attribute=nil)
        permissions.set(
          :actor => actor,
          :verb => verb,
          :subject => self,
          :perm => false
        )
      end

      def permission(options)
        options[:subject] = self
        permissions.set(options)
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

