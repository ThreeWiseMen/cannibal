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

end
