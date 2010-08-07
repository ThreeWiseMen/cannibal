require 'singleton'

module Cannibal
  class PermissionRegistry
    include Singleton

    def allow_class(actor, verb, subject)
      verb_hash(actor, subject, verb)[:perm] = true
    end

    def deny_class(actor, verb, subject)
      verb_hash(actor, subject, verb)[:perm] = false
    end

    def allow(options)
      actor = options[:actor]
      verb = options[:verb]
      subject = options[:subject]
      actor_proc = options[:actor_proc]
      verb_hash(actor, subject, verb)[:actor_proc] = actor_proc unless actor_proc.nil?
      proc = options[:proc]
      verb_hash(actor, subject, verb)[:proc] = proc unless proc.nil?
    end

    def allowed?(actor, verb, subject)
      ok = false

      # Check class perms first
      if actor.is_a? Class
        h = verb_hash(actor, subject, verb)
      else
        h = verb_hash(actor.class, subject, verb)
      end
      if h.has_key? :perm
        ok = h[:perm]
      end

      unless actor.is_a? Class
        # Allow object perms to override
        h = verb_hash(actor.class, subject, verb)
        if h.has_key? :actor_proc
          ok = h[:actor_proc].call actor
        end
      end

      unless subject.is_a? Class
        # Allow object-to-object perms to override
        h = verb_hash(actor.class, subject.class, verb)
        if h.has_key? :proc
          ok = h[:proc].call actor, subject
        end
      end

      ok
    end

    def permstore
      @perms ||= {}
    end

    def verb_hash(actor, subject, verb)
      actor_hash = hash_or_init permstore, actor
      subject_hash = hash_or_init actor_hash, subject
      hash_or_init subject_hash, verb
    end

    def hash_or_init(hash, key)
      unless hash.include? key
        hash[key] = {}
      end
      hash[key]
    end
  end
end
