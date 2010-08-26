require 'spec_helper'

describe Cannibal::Actor do
  before(:each) { class Eater; include Cannibal::Actor; end }
  let(:actor) { Eater.new }
  subject { actor }

  it { should respond_to(:can?) }

  describe "#can?" do

    context "on a subject without a can method" do
      before(:each) { class Victim; end }
      let(:victim) { Victim.new }

      context "when Cannibal is using its default optimism" do
        before(:each) { Cannibal.configuration.default_optimism! }

        it "should return false" do
          actor.can?(:eat, victim).should be_false
        end
      end

      context "when Cannibal is configured to be pessimistic" do
        before(:each) { Cannibal.configuration.pessimistic! }

        it "should return false" do
          actor.can?(:eat, victim).should be_false
        end
      end

      context "when Cannibal is configured to be optimistic" do
        before(:each) { Cannibal.configuration.optimistic! }

        it "should return true" do
          actor.can?(:eat, victim).should be_true
        end
      end

      after(:each) { Cannibal.configuration.default_optimism! }
    end

    context "on a subject with a can method" do
      before(:each) do
        @victim = Object.new
        @victim.stub(:can_eater_eat?).and_return(false)
      end

      it "should call the can method" do
        @victim.should_receive(:can_eater_eat?)
        actor.can?(:eat, @victim)
      end

      it "should return the value returned by the can method" do
        actor.can?(:eat, @victim).should be_false
      end

    end

  end
end
