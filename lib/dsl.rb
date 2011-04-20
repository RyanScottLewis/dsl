#!/usr/bin/env ruby

class DSL  
  def self.call(parent, &blk)
    instance = new
    # Add all of the parents instance variables to the instance
    parent.instance_variables.each do |instance_variable|
      value = parent.instance_variable_get(instance_variable)
      instance.instance_variable_set(instance_variable, value)
    end
    instance.instance_eval(&blk) # Instance eval the block in the instance
    # Replace all of the parents instance variables with the instance's
    instance.instance_variables.each do |instance_variable|
      value = instance.instance_variable_get(instance_variable)
      parent.instance_variable_set(instance_variable, value)
    end
    parent # Return the parent for convenience
  end
end