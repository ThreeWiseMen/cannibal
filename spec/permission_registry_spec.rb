require 'spec_helper'

describe Cannibal::PermissionRegistry do

  context "initializes as a singleton" do
    subject { Cannibal::PermissionRegistry.instance }
    it { should_not be_nil }
    it { should be_instance_of Cannibal::PermissionRegistry }
    it { should respond_to :set }
    it { should respond_to :allowed? }
  end

  context "stores class level permissions" do
    before(:all) do
      @registry = Cannibal::PermissionRegistry.instance
      @registry.reset
      class Actor; end
      class Subject; end
    end

    it "should register a permission" do
      @registry.set({:actor => Actor, :verb => :edit, :subject => Subject, :perm => true})
      @registry.allowed?(Actor, Subject, :edit).should be_true
      @registry.allowed?(Actor, Subject, :delete).should be_false
    end
  end

  context "stores object level permissions" do
    before(:all) do
      @registry = Cannibal::PermissionRegistry.instance
      @registry.reset
      class Actor; attr_accessor :role; end
      class Subject; end
      @admin = Actor.new; @admin.role = 'administrator'
      @user = Actor.new; @user.role = 'user'
    end

    it "should register a permission" do
      @registry.set(
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
      @registry.allowed?(@admin, Subject, :edit).should be_true
      @registry.allowed?(@user, Subject, :edit).should be_false
    end
  end

  context "stores object-to-object level permissions" do
    before(:all) do
      @registry = Cannibal::PermissionRegistry.instance
      @registry.reset
      class Actor; attr_accessor :role; end
      class Subject; attr_accessor :owner; end
      @admin = Actor.new; @admin.role = 'administrator'
      @user_a = Actor.new; @user_a.role = 'user'
      @user_b = Actor.new; @user_b.role = 'user'
      @subject = Subject.new; @subject.owner = @user_a
    end

    it "should register a permission" do
      @registry.set(
        :actor => Actor,
        :verb => :edit,
        :subject => Subject,
        :proc => Proc.new{ |actor, subject|
          if actor.role == 'administrator' || actor == subject.owner
            true
          else
            false
          end
        }
      )
      @registry.allowed?(@admin, @subject, :edit).should be_true
      @registry.allowed?(@user_a, @subject, :edit).should be_true
      @registry.allowed?(@user_b, @subject, :edit).should be_false
    end
  end

  context "stores object attribute level permissions" do
    before(:all) do
      @registry = Cannibal::PermissionRegistry.instance
      @registry.reset
      class Actor; end
      class Subject; attr_accessor :name, :phone; end
    end
    it "should register an attribute permission" do
      @registry.set({
        :actor => Actor,
        :verb => :edit,
        :subject => Subject,
        :perm => true,
        :attribute => :phone
      })
      @registry.allowed?(Actor, Subject, :edit, :phone).should be_true
      @registry.allowed?(Actor, Subject, :edit, :name).should be_false
    end
  end

  context "stores object and attribute level permissions" do
    before(:all) do
      @registry = Cannibal::PermissionRegistry.instance
      @registry.reset
      class Actor; attr_accessor :role; end
      class Subject; attr_accessor :name, :phone, :email; end
    end
    it "should register an attribute permission" do
      @registry.set({
        :actor => Actor,
        :verb => :edit,
        :subject => Subject,
        :attribute => [ :phone, :email ],
        :actor_proc => Proc.new{ |actor|
          if actor.role == 'administrator'
            true
          else
            false
          end
        }
      })
      @admin = Actor.new; @admin.role = 'administrator'
      @user = Actor.new; @user.role = 'user'
      @registry.allowed?(@admin, Subject, :edit, :name).should_not be_true
      @registry.allowed?(@admin, Subject, :edit, :phone).should be_true
      @registry.allowed?(@admin, Subject, :edit, :email).should be_true
      @registry.allowed?(@user, Subject, :edit, :name).should_not be_true
      @registry.allowed?(@user, Subject, :edit, :phone).should_not be_true
      @registry.allowed?(@user, Subject, :edit, :email).should_not be_true
    end
  end

end
