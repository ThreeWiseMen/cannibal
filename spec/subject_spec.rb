require 'spec_helper'

describe Cannibal::Subject do

  context "when included in a class" do
    before(:all) do
      class FooSubject
        include Cannibal::Subject
      end
    end

    subject { FooSubject }

    it { should respond_to(:allow) }
    it { should respond_to(:deny) }
    it { should respond_to(:permissions) }
  end

  context "when a simple class-level permission is set" do
    before(:all) do
      class FooActor
        include Cannibal::Actor
      end
      class FooSubject
        include Cannibal::Subject
        allow FooActor, :view
      end
    end

    it "should allow FooActor to view FooSubject's name" do
      FooActor.can?(:view, FooSubject).should be_true
    end

    it "should not allow FooActor to edit FooSubject's name" do
      FooActor.can?(:edit, FooSubject).should be_false
    end
  end

  context "when a simple object-level permission is set" do
    before(:all) do
      class BarActor
        include Cannibal::Actor
      end
      class BarSubject
        include Cannibal::Subject
        allow BarActor, :view
      end
    end

    it "should allow BarActor to view BarSubject's name" do
      BarActor.new.can?(:view, BarSubject).should be_true
    end

  end

  context "when a run-time object-level permission is set" do
    before(:all) do
      class RoleActor
        include Cannibal::Actor
        attr_accessor :role
      end
      class RoleSubject
        include Cannibal::Subject
        permission({
          :actor => RoleActor,
          :verb => :edit,
          :actor_proc => Proc.new{ |actor|
            if actor.role == 'administrator'
              true
            else
              false
            end
          }
        })
      end
      @admin = RoleActor.new; @admin.role = 'administrator'
      @user = RoleActor.new; @user.role = 'user'
    end

    it "should register a permission" do
      @admin.can?(:edit, RoleSubject).should be_true
      @user.can?(:edit, RoleSubject).should be_false
    end
  end

  context "when a run-time object-to-object level permission is set" do
    before(:all) do
      class RoleActor
        include Cannibal::Actor
        attr_accessor :role
      end
      class OwnableSubject
        include Cannibal::Subject
        attr_accessor :owner
        permission({
          :actor => RoleActor,
          :verb => :edit,
          :proc => Proc.new { |actor,subject|
            if actor.role == 'administrator' || actor == subject.owner
              true
            else
              false
            end
          }
        })
      end
      @admin = RoleActor.new; @admin.role = 'administrator'
      @user_a = RoleActor.new; @user_a.role = 'user'
      @user_b = RoleActor.new; @user_b.role = 'user'
      @subject = OwnableSubject.new; @subject.owner = @user_a
    end

    it "should register a permission" do
      @admin.can?(:edit, @subject).should be_true
      @user_a.can?(:edit, @subject).should be_true
      @user_b.can?(:edit, @subject).should be_false
    end
  end

  context "when I disallow an attribute level permission" do
    before(:all) do
      class User
        include Cannibal::Actor
      end
      class Thing
        include Cannibal::Subject
        attr_accessor :name, :phone
        allow User, :edit, :phone
      end
    end
    it "should allow User to edit Thing's phone" do
      User.can?(:edit, Thing, :phone).should be_true
    end
    it "should not allow User to edit Thing's name" do
      User.can?(:edit, Thing, :name).should be_false
    end
  end

  context "when I allow an actor object some attribute level permissions" do
    before(:all) do
      Cannibal::PermissionRegistry.instance.reset
      class User
        include Cannibal::Actor
        attr_accessor :role
      end
      class Thing
        include Cannibal::Subject
        attr_accessor :name, :phone, :email
        allow User, :view
        permission({
          :actor => User,
          :verb => :edit,
          :attribute => [ :phone, :email ],
          :actor_proc => Proc.new{ |actor|
            actor.role == 'administrator'
          }
        })
      end
      @admin = User.new; @admin.role = 'administrator'
      @user = User.new; @user.role = 'user'
      @thing = Thing.new
    end
    it "should allow @user to view all attributes but not edit" do
      @user.can?(:view, @thing, :name).should be_true
      @user.can?(:view, @thing, :phone).should be_true
      @user.can?(:view, @thing, :email).should be_true
      @user.can?(:edit, @thing, :name).should be_false
      @user.can?(:edit, @thing, :phone).should be_false
      @user.can?(:edit, @thing, :email).should be_false
    end
    it "should allow @admin to view name and edit phone/email" do
      @admin.can?(:view, @thing, :name).should be_true
      @admin.can?(:view, @thing, :phone).should be_true
      @admin.can?(:view, @thing, :email).should be_true
      @admin.can?(:edit, @thing, :name).should be_false
      @admin.can?(:edit, @thing, :phone).should be_true
      @admin.can?(:edit, @thing, :email).should be_true
    end
  end

  context "when I allow multiple verbs in one statement" do
    before(:all) do
      Cannibal::PermissionRegistry.instance.reset
      class User
        include Cannibal::Actor
        attr_accessor :role
      end
      class Thing
        include Cannibal::Subject
        attr_accessor :name, :phone, :email
        allow User, :view
        permission({
          :actor => User,
          :verb => [ :edit, :delete ],
          :actor_proc => Proc.new{ |actor|
            if actor.role == 'administrator'
              true
            else
              false
            end
          }
        })
      end
      @admin = User.new; @admin.role = 'administrator'
      @user = User.new; @user.role = 'user'
      @thing = Thing.new
    end
    it "should allow both verbs to operate on subject" do
      @admin.can?(:edit, @thing).should be_true
      @admin.can?(:delete, @thing).should be_true
      @admin.can?(:mangle, @thing).should be_false
    end
  end

  context "when single class is both actor and subject" do
    before(:all) do
      Cannibal::PermissionRegistry.instance.reset
      class Employee
        include Cannibal::Actor
        include Cannibal::Subject

        attr_accessor :role

        permission({
          :actor => Employee,
          :verb => [ :edit, :delete, :create ],
          :actor_proc => Proc.new{ |user|
            if user.role == 'administrator'
              true
            else
              false
            end
          }
        })
      end

      @admin = Employee.new; @admin.role = 'administrator'
      @user = Employee.new; @user.role = 'user'
    end
    it "should allow admin to edit user" do
      @admin.can?(:edit, @user).should be_true
      @admin.can?(:delete, @user).should be_true
      @admin.can?(:create, @user).should be_true
    end
    it "should not allow user to edit user" do
      @user.can?(:edit, @admin).should be_false
      @user.can?(:delete, @admin).should be_false
      @user.can?(:create, @admin).should be_false
    end
  end
end
