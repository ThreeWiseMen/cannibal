require 'spec_helper'

describe Cannibal::Actor do
  
  context "when included in a class" do
    before(:all) do
      class FooActor
        include Cannibal::Actor
      end
    end
    
    subject { FooActor.new }
    it { should respond_to(:can?) }
  end
end
