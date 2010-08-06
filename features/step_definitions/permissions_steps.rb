Given /^I have a class named "([^"]*)"$/ do |name|
  eval "class #{name}; end"
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
  subject_class.send :allow, actor_class, verb_sym, :attribute
end

When /^I create a new instance of "([^"]*)" and assign it to an instance variable "([^"]*)"$/ do |klass, ivar_name|
  c = constantize(klass)
  instance_variable_set(ivar_name.intern, c.new)
end

Then /^the instance variable "([^"]*)" should be allowed to "([^"]*)" the "([^"]*)" of an "([^"]*)"$/ do |arg1, arg2, arg3, arg4|
  pending # express the regexp above with the code you wish you had
end

When /^I declare that a "([^"]*)" cannot "([^"]*)" the "([^"]*)" of an "([^"]*)"$/ do |arg1, arg2, arg3, arg4|
  pending # express the regexp above with the code you wish you had
end

Then /^the instance variable "([^"]*)" should not be allowed to "([^"]*)" the "([^"]*)" of an "([^"]*)"$/ do |arg1, arg2, arg3, arg4|
  pending # express the regexp above with the code you wish you had
end
