module DSL
  class DelegateInstanceVariables
    def self.call(parent, &blk)
      instance = new
      # Add all of the parents instance variables to this instance
      parent.instance_variables.each do |instance_variable|
        value = parent.instance_variable_get(instance_variable)
        instance.instance_variable_set(instance_variable, value)
      end
      instance.instance_eval(&blk) # Instance eval the block in this instance
      # Replace all of the parent's instance variables with this instances
      instance.instance_variables.each do |instance_variable|
        value = instance.instance_variable_get(instance_variable)
        parent.instance_variable_set(instance_variable, value)
      end
      parent # Return the parent for convenience
    end
  end
end