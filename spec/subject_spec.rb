require 'spec_helper'

describe Cannibal::Subject do
  before(:each) do
    class Eater
    end

    class Victim
      include Cannibal::Subject
    end
  end
  subject { Victim }

  it { should respond_to(:allow) }

  describe ".allow" do
    before(:each) { subject.allow Eater, :eat }

    it "should define a method to check if an object can act on a Subject instance" do
      subject.new.should respond_to(:can_eater_eat?)
    end

    it "should return true by default" do
      subject.new.can_eater_eat?.should be_true
    end
  end
end
