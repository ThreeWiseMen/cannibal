require 'spec_helper'
require 'cannibal'

describe Cannibal::Subject do

  context "when included in a class" do
    before(:all) do
      class Foo
        include Cannibal::Subject
      end
    end

    subject { Foo }

    it { should respond_to(:allow) }
  end

end

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