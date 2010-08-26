require 'spec_helper'

describe Cannibal::Configuration do
  subject { Cannibal::Configuration.new }

  describe "#optimistic?" do
    it "should be false by default" do
      subject.optimistic?.should be_false
    end
  end

  describe "#pessimistic!" do
    it "should set the optimism to be false" do
      subject.pessimistic!
      subject.optimistic?.should be_false
    end
  end

  describe "#optimistic!" do
    it "should set the optimism to be true" do
      subject.optimistic!
      subject.optimistic?.should be_true
    end
  end

  describe "#default_optimism!" do
    it "should set the optimism to be false" do
      subject.default_optimism!
      subject.optimistic?.should be_false
    end
  end

end
