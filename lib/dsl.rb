require 'pathname'

__LIB__ ||= Pathname.new(__FILE__).dirname
$:.unshift(__LIB__.to_s) unless $:.include?(__LIB__.to_s)

require 'core_ext/string/underscore'

class DSL
  class << self
    
    # If the last argument is **not** a Hash, then the *first* argument will be defined as `@parent` on the DSL instance.  
    # All other arguments will be passed to the `initialize` method of the DSL instance.
    # 
    # If the last argument **is** a `Hash`, the keys will be transformed into an `underscore`'d String, then into a `Symbol`.  
    # If the key does not start with an "at" (`@`) character, we will prepend one to it.  
    # This means `:foo` and `:@foo` are equivalent and you can set class variables as well by using `:@@class_iv`.
    # 
    # Each key is then defined as an instance variable on the `DSL` instance with the object given as the value.  
    # All other arguments will be passed to the `initialize` method of the `DSL` instance.
    #
    # The block passed to this method will be instanced eval'd BEFORE initialize is called.
    # 
    # The DSL instance is returned.
    def call(*args, &blk)
      instance_variables = args.last.instance_of?(Hash) ? args.pop : {}
      instance_variables[:parent] = args.shift if instance_variables.empty?
      
      instance = allocate
      
      instance_variables.each do |instance_variable, value|
        instance_variable = instance_variable.to_s.underscore
        instance_variable.prepend(?@) unless instance_variable.start_with?(?@)
        instance.instance_variable_set(instance_variable.to_sym, value)
      end
      
      instance.instance_eval(&blk)
      
      instance.send(:initialize, *args) # initialize is a private method
      
      instance
    end
    
    # Defines a method that accepts a variable number of arguments that will delegate to the `@parent`.  
    # This will attempt to call the setter/getter method before attempting to access the instance variable.  
    # This way, any modifications you do to the instance variables in those methods will be used.
    def def_dsl_delegator(*method_names)
      target_name = method_names.first.to_s.start_with?(?@) ? method_names.shift : :@parent
      
      method_names.each do |method_name|
        raise TypeError unless method_name.respond_to?(:to_sym)
        
        method_name = method_name.to_sym
        
        define_method(method_name) do |*args|
          target = instance_variable_get(target_name)
          
          unless args.empty?
            args = args.first if args.length == 1
            target.respond_to?("#{method_name}=") ? target.send("#{method_name}=", args) : target.instance_variable_set("@#{method_name}", args)
          end
          
          target.respond_to?(method_name) ? target.send(method_name) : target.instance_variable_get("@#{method_name}")
        end
        
      end
    end
    
  end
end
