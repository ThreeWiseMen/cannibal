require 'spec_helper'

describe Cannibal::Subject do
  before(:each) do
    class Eater; end
    class Victim; include Cannibal::Subject; end
  end
  subject { Victim }

  it { should respond_to(:allow) }

  describe '.allow' do
    let(:victim_instance) { Victim.new }

    context 'when called without a block' do
      before(:each) do
        class Victim
          allow Eater, :eat
        end
      end

      it 'should define a method to check if an object can act on a Subject instance' do
        victim_instance.should respond_to(:can_eater_eat?)
      end

      describe 'can_#{actor}_#{verb}?' do
        it 'should return true by default' do
          victim_instance.can_eater_eat?.should be_true
        end
      end
    end

    context 'when called with a block' do
      before(:each) do
        class Victim
          allow Eater, :eat do |eater|
            false
          end
        end
      end
      let(:actor_instance) { Eater.new }

      it 'should define a method to check if an object can act on a Subject instance' do
        victim_instance.should respond_to(:can_eater_eat?)
      end

      describe 'can_#{actor}_#{verb}?' do
        it 'should take an actor as an argument' do
          victim_instance.can_eater_eat?(actor_instance).should_not raise_exception(ArgumentError)
        end

        it 'should return the value yielded from the block' do
          victim_instance.can_eater_eat?(actor_instance).should be_false
        end
      end
    end

  end
end
