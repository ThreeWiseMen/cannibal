Given /^I have a class named "([^"]*)"$/ do |name|
  eval "class #{name}; end"
end

Given /^I have a class named "([^"]*)" that has a role$/ do |name|
  eval "class #{name}; attr_accessor :role; end"
end

Given /^I have a class named "([^"]*)" that has an owner$/ do |name|
  eval "class #{name}; attr_accessor :owner; end"
end

When /^I (extend|include) "([^"]*)" with "([^"]*)"$/ do |message, target_klass, extender_module|
  klass = constantize(target_klass)
  extender = constantize(extender_module)
  klass.send message.intern, extender
end

When /^I allow a "([^"]*)" to "([^"]*)" the "([^"]*)" of an? "([^"]*)"$/ do |actor, verb, attribute, subject|
  actor_class = constantize(actor)
  verb_sym = verb.intern
  attr_sym = attribute.intern
  subject_class = constantize(subject)
  subject_class.send :allow, actor_class, verb_sym, attr_sym
end

When /^I create a new instance of "([^"]*)" and assign it to an instance variable "([^"]*)"$/ do |klass, ivar_name|
  c = constantize(klass)
  instance_variable_set(ivar_name.intern, c.new)
end

When /^I set the "([^"]*)" attribute of the instance variable "([^"]*)" to "([^"]*)"$/ do |attribute, ivar_name, value|
  obj = instance_variable_get(ivar_name.intern)
  attr_sym = "#{attribute}=".intern
  obj.send attr_sym, value
end

Then /^the instance variable "([^"]*)" should be allowed to "([^"]*)" the "([^"]*)" of an? "([^"]*)"$/ do |ivar_name, verb, attribute, subject|
  actor = instance_variable_get(ivar_name.intern)
  verb_sym = verb.intern
  subject_class = constantize(subject)
  actor.can?(verb_sym, subject_class, attribute).should be_true
end

When /^I declare that a "([^"]*)" cannot "([^"]*)" the "([^"]*)" of an "([^"]*)"$/ do |actor, verb, attribute, subject|
  actor_class = constantize(actor)
  verb_sym = verb.intern
  attr_sym = attribute.intern
  subject_class = constantize(subject)
  subject_class.send :deny, actor_class, verb_sym, attr_sym
end

Then /^the instance variable "([^"]*)" should not be allowed to "([^"]*)" the "([^"]*)" of an "([^"]*)"$/ do |ivar_name, verb, attribute, subject|
  actor = instance_variable_get(ivar_name.intern)
  verb_sym = verb.intern
  subject_class = constantize(subject)
  actor.can?(verb_sym, subject_class, attribute).should be_false
end

When /^I declare that only a "([^"]*)" with the role "([^"]*)" can "([^"]*)" an "([^"]*)"$/ do |actor, role, verb, subject|
  actor_class = constantize(actor)
  subject_class = constantize(subject)
  verb_sym = verb.intern
  subject_class.send(
    :allow_obj,
    {
      :actor => actor_class,
      :verb => verb_sym,
      :actor_proc => Proc.new{ |actor|
        if actor.role == role
          true
        else
          false
        end
      }
    }
  )
end

