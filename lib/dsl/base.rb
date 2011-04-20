require 'meta_tools'

module DSL
  # The base module for Domain Specific Languages, 
  # all of which have a class method `call`.
  # 
  # Make sure to `include` not `extend` in your DSL classes.
  # 
  # It's worth noting that not all DSL classes *need* 
  # the instance variable `@result`. In fact, not all DSL 
  # classes will even include this module.
  module Base
    def self.call(&blk)
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