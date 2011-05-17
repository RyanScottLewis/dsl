#!/usr/bin/env ruby

class DSL
  class << self
    def use(middleware, *args, &blk)
    
    end
    
    def dsl_def(*meths, args={}, &blk)
    
    end
    
    def call(*args, &blk)
      # We run blocks in order and return the last result
      @on_call_blocks.each { |b| b.call(*args) } if instance_variable_defined?(:@on_call_blocks)
    end
    
    def method_missing(meth, *args, &blk)
      # We run blocks in order and return the last result
      @on_method_missing_blocks.each { |b| b.call(*args) } if instance_variable_defined?(:@on_method_missing_blocks)
    end
    
    def on_call(&blk); (@on_call_blocks ||= []) << blk; end
    def on_method_missing(&blk); (@on_method_missing_blocks ||= []) << blk; end
  end
end

class MyDSL < DSL

end

p MyDSL.call(:arg => "meh") do
 
end
