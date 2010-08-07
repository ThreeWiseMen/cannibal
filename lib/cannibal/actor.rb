module Cannibal
  module Actor

    module ClassMethods
      def can?(verb, subject, attribute)
        permissions.allowed?(self, verb, subject)
      end

      def permissions
        @@registry = Cannibal::PermissionRegistry.instance
      end
    end

    def self.included(klass)
      klass.extend ClassMethods
    end

    def can?(verb, subject, attribute)
      self.class.permissions.allowed?(self, verb, subject)
    end

  end
end

# allow = Proc.new { true }
# deny = Proc.new { false }
# 
# @@perms ||= {
#   Actor.class => {
#     Subjects.class => {
#       :view => allow
#       :edit => Proc.new { }
#       :delete => deny
#       :attributes => {
#         :field_name => allow
#       }
#     }
#   }
# }
# 
# Proc.new { |actor, subject| {
#     return true if actor.is_administrator?
#     return true if subject.owner == actor
#     false
#   }
# }
# 
