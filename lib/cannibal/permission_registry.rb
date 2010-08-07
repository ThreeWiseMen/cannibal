require 'singleton'

module Cannibal
  class PermissionRegistry
    include Singleton

    def set(options)
      actor = options[:actor]
      verb = options[:verb]
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

      actor_proc = options[:actor_proc]
      verb_hash(actor_class, subject_class, verb)[:actor_proc] = actor_proc unless actor_proc.nil?

      gproc = options[:proc]
      verb_hash(actor_class, subject_class, verb)[:proc] = gproc unless gproc.nil?

      perm = options[:perm]
      attributes = options[:attribute]
      if attributes.nil?
        # Set class-wide perms if no attributes specified
        verb_hash(actor_class, subject_class, verb)[:perm] = perm unless perm.nil?
      else
        attributes = [ attributes ] unless attributes.is_a? Array
        attributes.each do |attribute|
          attribute_hash(actor_class, subject_class, verb)[attribute] = perm
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
        ah = attribute_hash(actor_class, subject_class, verb)
        if ah.has_key? attribute
          ok = ah[attribute]
        end
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
