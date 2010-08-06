Given /^I have a class named "([^"]*)"$/ do |name|
  eval "class #{name}; end"
end

When /^I include the "([^"]*)" module into "([^"]*)"$/ do |mod, obj|
  m = constantize(mod)
  o = constantize(obj)
  o.class.send :include, m
end

When /^I extend the "([^"]*)" class with "([^"]*)"$/ do |klass, obj|
  c = constantize(klass)
  o = constantize(obj)
  c.send :extend, o
end

When /^I declare that a "([^"]*)" can "([^"]*)" the "([^"]*)" of an "([^"]*)"$/ do |arg1, arg2, arg3, arg4|
  pending # express the regexp above with the code you wish you had
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
