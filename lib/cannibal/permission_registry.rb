require 'singleton'

module Cannibal
  class PermissionRegistry
    include Singleton

    def allow(actor, verb, subject)
      verb_hash(actor, subject, verb)[:perm] = true
    end

    def deny(actor, verb, subject)
      verb_hash(actor, subject, verb)[:perm] = false
    end

    def allowed?(actor, verb, subject)
      verb_hash(actor, subject, verb)[:perm] || false
    end

    def permstore
      @perms ||= {}
    end

    def verb_hash actor, subject, verb
      actor_hash = hash_or_init permstore, actor
      subject_hash = hash_or_init actor_hash, subject
      hash_or_init subject_hash, verb
    end

    def hash_or_init hash, key
      unless hash.include? key
        hash[key] = {}
      end
      hash[key]
    end
  end
end
