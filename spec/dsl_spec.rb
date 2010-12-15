require 'spec_helper'

describe DSL do
  class UserDSL < DSL
	  def name(n);   @name = n;   end
	  def gender(g); @gender = g; end
	  def age(a);    @age = a;    end
  end
	
  let(:user_klass) do
	  Class.new do
      attr :name, :gender, :age
      dsl_method :edit => UserDSL
    end
  end

  describe ".dsl_method" do
	  it "only supports Hash for parameter" do
		  expect {
			  user_klass
		  }.to_not raise_error

		  expect { 
			  Class.new do
				  dsl_method :edit 
			  end
		  }.to raise_error(TypeError)
	  end

	  it "creates the dsl method on calling class" do
		  user_klass.new.should be_respond_to :edit
	  end
  end
	
  context "calling on dsl method" do
	  let(:user) { user_klass.new }

	  it "must pass a block when calling dsl method" do
		  expect {
			  user.edit { }
		  }.to_not raise_error

		  expect {
			  user.edit 
		  }.to raise_error(ArgumentError)
	  end

	  it "assigns values to instance variables" do
		  user.edit do
			  name "my name"
			  age 26
			  gender "M"
		  end

		  user.name.should == "my name"
		  user.age.should == 26
		  user.gender.should == "M"
	  end
  end
end
