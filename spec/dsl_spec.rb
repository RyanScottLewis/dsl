require 'spec_helper'

class UserDSL < DSL
	def name(n);   @name = n;   end
	def gender(g); @gender = g; end
	def age(a);    @age = a;    end
end

describe DSL, ".dsl_method"do
	let(:user_klass) do
		Class.new do
      attr :name, :gender, :age
      dsl_method :edit => UserDSL
    end
	end

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

	it "must to pass a block when calling dsl method" do
		obj = user_klass.new

		expect {
			obj.edit { }
		}.to_not raise_error

		expect {
			obj.edit 
		}.to raise_error
	end
end
