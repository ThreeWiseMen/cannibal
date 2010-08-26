require 'spec_helper'

describe Cannibal::Helpers do
  describe ".can_method_name" do
    before(:each) { class Eater; end }
    let(:eater) { Eater.new }
    context "when given an actor and an action" do
      it 'should return a name in the form "can_#{actor}_#{action}?"' do
        class_name = eater.class.name
        name = Cannibal::Helpers.can_method_name(class_name, :eat)
        name.should == "can_eater_eat?"
      end
    end

    context "when given an actor, action, and attribute" do
      it 'should return a name in the form "can_#{actor}_#{action}_#{attribute}?"' do
        class_name = eater.class.name
        name = Cannibal::Helpers.can_method_name(class_name, :eat, :flesh)
        name.should == "can_eater_eat_flesh?"
      end
    end

  end
end
