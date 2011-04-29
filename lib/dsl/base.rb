require 'meta_tools'

module DSL
  # The base class for Domain Specific Languages, 
  # all of which have a method `call` and an instance variable `@result`
  # 
  # Also included are a couple of methods handy for meta-programming
  class Base
    def call(&blk)
      instance_eval(&blk)
      result = instance_variable_get(:@result)
      instance_variable_set(:@result, nil)
      result
    end
  end
  # The base module for Domain Specific Languages, 
  # all of which have a class method `call` and 
  # an instance variable `@result`.
  # 
  # Make sure to `extend` in your DSL classes.
  # 
  # It's worth noting that not all DSL classes *need* 
  # the instance variable `@result`. In fact, not all DSL 
  # classes will even include this module.
  module ReturnsResult
    def call(&blk)
      instance = new
      # We're counting on the class this is included in
      # will set the instance variable `@result`.
      instance.instance_eval(&blk)
      result = instance.instance_variable_get(:@result)
      instance.remove_instance_variable(:@result)
      result
    end
  end
end