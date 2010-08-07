require 'spec_helper'

describe Cannibal::PermissionRegistry do

  context "initializes as a singleton" do
    subject { Cannibal::PermissionRegistry.instance }
    it { should_not be_nil }
    it { should be_instance_of Cannibal::PermissionRegistry }
    it { should respond_to :allow_class }
    it { should respond_to :deny_class }
    it { should respond_to :allowed? }
  end

  context "stores class level permissions" do
    before(:all) do
      @registry = Cannibal::PermissionRegistry.instance
      class Actor; end
      class Subject; end
    end

    it "should register a permission" do
      @registry.allow_class(Actor, :edit, Subject)
      @registry.allowed?(Actor, :edit, Subject).should be_true
      @registry.allowed?(Actor, :delete, Subject).should be_false
    end
  end

  context "stores object level permissions" do
    before(:all) do
      @registry = Cannibal::PermissionRegistry.instance
      class Actor; attr_accessor :role; end
      class Subject; end
      @admin = Actor.new; @admin.role = 'administrator'
      @user = Actor.new; @user.role = 'user'
    end

    it "should register a permission" do
      @registry.allow(
        :actor => Actor,
        :verb => :edit,
        :subject => Subject,
        :actor_proc => Proc.new{ |actor|
          if actor.role == 'administrator'
            true
          else
            false
          end
        }
      )
      @registry.allowed?(@admin, :edit, Subject).should be_true
      @registry.allowed?(@user, :edit, Subject).should be_false
    end
  end

  context "stores object-to-object level permissions" do
    before(:all) do
      @registry = Cannibal::PermissionRegistry.instance
      class Actor; attr_accessor :role; end
      class Subject; attr_accessor :owner; end
      @admin = Actor.new; @admin.role = 'administrator'
      @user_a = Actor.new; @user_a.role = 'user'
      @user_b = Actor.new; @user_b.role = 'user'
      @subject = Subject.new; @subject.owner = @user_a
    end

    it "should register a permission" do
      @registry.allow(
        :actor => Actor,
        :verb => :edit,
        :subject => Subject,
        :proc => Proc.new{ |actor, subject|
          if actor.role == 'administrator' or actor == subject.owner
            true
          else
            false
          end
        }
      )
      @registry.allowed?(@admin, :edit, @subject).should be_true
      @registry.allowed?(@user_a, :edit, @subject).should be_true
      @registry.allowed?(@user_b, :edit, @subject).should be_false
    end
  end

end
