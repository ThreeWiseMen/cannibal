require 'singleton'

module Cannibal
  class PermissionRegistry
    include Singleton

    def set(options)
      actor = options[:actor]
      subject = options[:subject]

      if actor.is_a? Class
        actor_class = actor
      else
        actor_class = actor.class
      end

      if subject.is_a? Class
        subject_class = subject
      else
        subject_class = subject.class
      end

      perm = options[:perm]
      actor_proc = options[:actor_proc]
      gproc = options[:proc]

      verbs = options[:verb]
      verbs = [ verbs ] unless verbs.is_a? Array

      verbs.each do |verb|

        attributes = options[:attribute]
        if attributes.nil?
          # Set class-wide perms if no attributes specified
          verb_hash(actor_class, subject_class, verb)[:perm] = perm unless perm.nil?
          verb_hash(actor_class, subject_class, verb)[:actor_proc] = actor_proc unless actor_proc.nil?
          verb_hash(actor_class, subject_class, verb)[:proc] = gproc unless gproc.nil?
        else
          attributes = [ attributes ] unless attributes.is_a? Array
          attributes.each do |attribute|
            attribute_hash(actor_class, subject_class, verb)[attribute] = {}
            attribute_hash(actor_class, subject_class, verb)[attribute][:perm] = perm unless perm.nil?
            attribute_hash(actor_class, subject_class, verb)[attribute][:actor_proc] = actor_proc unless actor_proc.nil?
            attribute_hash(actor_class, subject_class, verb)[attribute][:proc] = gproc unless gproc.nil?
          end
        end

      end
    end

    def allowed?(actor, subject, verb, attribute=nil)
      ok = false

      if actor.is_a? Class
        actor_class = actor
      else
        actor_class = actor.class
      end
      if subject.is_a? Class
        subject_class = subject
      else
        subject_class = subject.class
      end

      ph = verb_hash(actor_class, subject_class, verb)
#puts "\n########### PERM HASH FOR #{actor_class} #{subject_class} #{verb} #{attribute}"
#puts "#{ph.inspect}\n\n"

      # Check class perms first
      if ph.has_key? :perm
        ok = ph[:perm]
      end

      unless actor.is_a? Class
        # Allow object perms to override
        if ph.has_key? :actor_proc
          ok = ph[:actor_proc].call actor
        end
      end

      unless subject.is_a? Class
        # Allow object-to-object perms to override
        if ph.has_key? :proc
          ok = ph[:proc].call actor, subject
        end
      end

      unless attribute.nil?
#        puts "Evaluating attribute #{attribute}"
        ah = attribute_hash(actor_class, subject_class, verb)
#        puts ah.inspect
        if ah.has_key? attribute
#          puts "Found key #{attribute}"

          if ah[attribute].has_key? :perm
#            puts "Setting from perm"
            ok = ah[attribute][:perm]
          end

          unless actor.is_a? Class or ah[attribute][:actor_proc].nil?
#            puts "Setting from actor_proc"
            ok = ah[attribute][:actor_proc].call actor
          end

          unless subject.is_a? Class or ah[attribute][:proc].nil?
#            puts "Setting from proc"
            ok = ah[attribute][:proc].call actor, subject
          end
        end
#        puts "Found #{ok}"
      end

      ok
    end

    def permstore
      @perms ||= {}
    end

    def reset
      @perms = {}
    end

    def verb_hash(actor, subject, verb)
      actor_hash = hash_or_init permstore, actor
      subject_hash = hash_or_init actor_hash, subject
      hash_or_init subject_hash, verb
    end

    def attribute_hash(actor, subject, verb)
      hash_or_init verb_hash(actor, subject, verb), :attributes
    end

    def hash_or_init(hash, key)
      unless hash.include? key
        hash[key] = {}
      end
      hash[key]
    end
  end
end
