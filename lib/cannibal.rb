module Cannibal
  class Actor
    def can? operation, subject

      ok = false # default to no permission

      if subject.is_a? Symbol
        subject_class = Object.const_get(subject.to_s.capitalize)
      else
        subject_class = subject.class
      end

      actor_class = self.class

      p = permissions_for actor_class, subject_class

      if p.include? operation
        ok = p[operation].call(self, subject)
      end

    end

    def self.permissions_for actor_class, subject_class
      subject_class.permissions_for actor_class, subject_class
    end

  end
  module Subject

    # Initialize permissions class variable, this needs to be distint for each subject
    def self.permissions
      @@perms ||= {} # Are we going to get the correct @@perms object?
    end

    # permissions[:actor_class][:subject_class] gives verbs hash
    def self.permissions_for actor_class, subject_class
      unless permissions.include? :actor_class
        permissions[:actor_class] = {}
      end
      unless permissions[:actor_class].include? subject_class
        permissions[:actor_class][:subject_class] = {}
      end
      permissions[:actor_class][:subject_class]
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
