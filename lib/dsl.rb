#!/usr/bin/env ruby

class DSL  
  def self.call(parent, &blk)
    instance = new
    # Add all of the parents instance variables to the instance
    parent.instance_variables.each do |instance_variable|
      value = parent.instance_variable_get(instance_variable)
      instance.instance_variable_set(instance_variable, value)
    end
    # Instance eval the block in the instance
    instance.instance_eval(&blk)
    # Replace all of the parents instance variables with the instance's
    instance.instance_variables.each do |instance_variable|
      value = instance.instance_variable_get(instance_variable)
      parent.instance_variable_set(instance_variable, value)
    end
  end
end
 
class Module
  def dsl_method(opts)
    # Complain if the argument isn't a hash
    raise(TypeError) unless opts.is_a?(Hash)
    # For each dsl_method, define it in the class
    # The methods do not accept arguments, only blocks
    opts.each do |method, dsl_class|
      define_method(method) do |&blk|
        raise(ArgumentError, "method #{method} requires a block") unless !!blk
        dsl_class.call(self, &blk)
      end
    end
  end
end
