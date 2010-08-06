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
    it { should respond_to(:permissions_for) }
  end

  context "when a simple permission is set" do
    before(:all) do
      class FooActor
        include Cannibal::Actor
      end
      class FooSubject
        include Cannibal::Subject
        allow FooActor, :edit, :name
      end
    end

    subject { FooSubject }

    it { FooActor.new.can?(FooSubject, :edit, :name).should be_true }
    it { FooActor.new.can?(FooSubject, :edit, :phone).should be_false }
  end

end
