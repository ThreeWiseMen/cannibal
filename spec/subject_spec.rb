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

  context "when a simple permission is set" do
    before(:all) do
      class FooActor
        include Cannibal::Actor
      end
      class FooSubject
        include Cannibal::Subject
        allow FooActor, :view, :name
      end
    end

    subject { FooSubject }

    it { FooActor.can?(:view, FooSubject, :name).should be_true }
    it { FooActor.can?(:edit, FooSubject, :name).should be_false }
  end

end
