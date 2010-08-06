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
  end

end
