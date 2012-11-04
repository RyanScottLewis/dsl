# module DSL
# end
# 
# $LOAD_PATH.unshift(File.dirname(__FILE__))
# 
# require 'dsl/return_hash'
# require 'dsl/delegate_instance_variables'


class DSL
  
  class << self
    
    def call(parent, &blk)
      # `instance_eval` returns the last thing in the block whereas `tap` return the Object that was tapped
      new(parent).tap { |instance| instance.instance_eval(&blk) }
    end
    
    # Defines a method that accepts a variable number of arguments
    # that will delegate to the parent.
    # This will attempt to call the setter/getter method before attempting to
    # access the instance variable. This way, any modifications you do to the 
    # instance variables in those methods will be used.
    def def_dsl_delegator(*method_names)
      method_names.each do |method_name|
        raise TypeError unless method_name.respond_to?(:to_sym)
        method_name = method_name.to_sym
        
        define_method(method_name) do |*args|
          unless args.empty?
            args = args.first if args.length == 1
            @parent.respond_to?("#{method_name}=") ? @parent.send("#{method_name}=", args) : @parent.instance_variable_set("@#{method_name}", args)
          end
          
          @parent.respond_to?(method_name) ? @parent.send(method_name) : @parent.instance_variable_get("@#{method_name}")
        end
        
      end
    end
    
  end
  
  def initialize(parent)
    @parent = parent
  end
  
end
