module Cannibal

  module Subject

    module ClassMethods

      def allow(actor, verb, attribute)
      end

      def deny(actor, verb, attribute)
      end

      def permissions
        @@perms ||= {} #Is this going to give us the correct @@perms object?
      end

      def permissions_for(actor_class, subject_class)
        unless permissions.include? :actor_class
          permissions[:actor_class] = {}
        end
        unless permissions[:actor_class].include? subject_class
          permissions[:actor_class][:subject_class] = {}
        end
        permissions[:actor_class][:subject_class]
      end
    end
  
    def self.included(klass)
      klass.extend ClassMethods
    end
  end
end

# Initialize permissions class variable, this needs to be distint for each subject
# def self.permissions
#   @@perms ||= {} # Are we going to get the correct @@perms object?
# end

# permissions[:actor_class][:subject_class] gives verbs hash
# def self.permissions_for actor_class, subject_class
#   unless permissions.include? :actor_class
#     permissions[:actor_class] = {}
#   end
#   unless permissions[:actor_class].include? subject_class
#     permissions[:actor_class][:subject_class] = {}
#   end
#   permissions[:actor_class][:subject_class]
# end
# 
