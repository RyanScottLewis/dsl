require 'spec_helper'

class ClassDSL < DSL
end

describe DSL, ".dsl_method"do
	it "only supports Hash for parameter" do
		expect {
			Class.new do
				dsl_method :edit => ClassDSL
			end
		}.to_not raise_error

		expect { 
			Class.new do
				dsl_method :edit 
			end
		}.to raise_error(TypeError)
	end
	
	it "creates the dsl method on calling class" do
		klass = Class.new do
			dsl_method :edit => ClassDSL
		end

		klass.new.should be_respond_to :edit
	end

	it "must to pass a block when calling dsl method" do
		klass = Class.new do
			dsl_method :edit => ClassDSL
		end
		obj = klass.new

		expect {
			obj.edit { }
		}.to_not raise_error

		expect {
			obj.edit 
		}.to raise_error
	end
end
