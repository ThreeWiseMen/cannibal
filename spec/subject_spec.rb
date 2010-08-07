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
        allow FooActor, :view, :name
      end
    end

    it "should allow FooActor to view FooSubject's name" do
      FooActor.can?(:view, FooSubject, :name).should be_true
    end

    it "should not allow FooActor to edit FooSubject's name" do
      FooActor.can?(:edit, FooSubject, :name).should be_false
    end
  end

  context "when a simple object-level permission is set" do
    before(:all) do
      class BarActor
        include Cannibal::Actor
      end
      class BarSubject
        include Cannibal::Subject
        allow BarActor, :view, :name
      end
    end

    it "should allow BarActor to view BarSubject's name" do
      BarActor.new.can?(:view, BarSubject, :name).should be_true
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
        allow_obj({
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
      @admin.can?(:edit, RoleSubject, :name).should be_true
      @user.can?(:edit, RoleSubject, :name).should be_false
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
        allow_obj({
          :actor => RoleActor,
          :verb => :edit,
          :proc => Proc.new{ |actor,subject|
            if actor.role == 'administrator' or actor == subject.owner
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
      @admin.can?(:edit, @subject, :name).should be_true
      @user_a.can?(:edit, @subject, :name).should be_true
      @user_b.can?(:edit, @subject, :name).should be_false
    end
  end

end
