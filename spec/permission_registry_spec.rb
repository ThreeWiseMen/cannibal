require 'spec_helper'

describe Cannibal::PermissionRegistry do

  context "initializes as a singleton" do
    subject { Cannibal::PermissionRegistry.instance }
    it { should_not be_nil }
    it { should be_instance_of Cannibal::PermissionRegistry }
    it { should respond_to :allow }
    it { should respond_to :deny }
    it { should respond_to :allowed? }
  end

  context "stores permissions" do
    before(:all) do
      @registry = Cannibal::PermissionRegistry.instance
      class Actor; end
      class Subject; end
    end

    it "should register a permission" do
      @registry.allow(Actor, :edit, Subject)
      @registry.allowed?(Actor, :edit, Subject).should be_true
      @registry.allowed?(Actor, :delete, Subject).should be_false
    end
  end

end
