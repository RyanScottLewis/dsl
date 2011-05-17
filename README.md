# DSL ![](http://stillmaintained.com/c00lryguy/dsl.png)

## Description

dsl.rb is a small script to help create domain specific languages within Ruby.

### Notice

> Undergoing a complete overhaul.
> 
> Old code WILL BREAK.  
> Current code is UNSTABLE.  
> You've been warned.

## Install

`gem update --system` 

`gem update` 

`gem install dsl`

## What is this?

`dsl` is a set of classes for creating Domain Specific Languages. 

Take the below for example: 
    
    require 'dsl'

    my_obj = DSL::ReturnHash.call do
      foo "bar"
      this :that
    end
    
    pp my_obj # => { :foo => "bar", :this => :that }

Harder example:

    require 'dsl/return_hash'

    class MyCoolDSL
      def initialize(&blk)
        vars = DSL::ReturnHash.call(&blk)
        vars.each do |k, v|
          instance_variable_set("@#{k}", v)
          define_method(k) do
            instance_variable_get("@#{k}")
          end
        end
      end
    end

    my_obj = MyCoolDSL.new do
      foo "bar"
      this :that
    end

    p my_obj.foo # => "bar"

Notice I've only required `dsl/return_hash` as we can only require 
the class we need.

Another example:

    require 'dsl/delegate_instance_variables'
    class User
      class UserDSL < DSL::DelegateInstanceVariables
        def name(val); @name = val; end
        def age(val); @age = val; end
      end

      def initialize(&blk)
        edit(&blk)
      end
      def edit(&blk)
        class_with_instance_variables_to_delegate = self
        UserDSL.call(class_with_instance_variables_to_delegate, &blk)
      end
    end

    # Create a new User
    my_user = User.new do
      name "Ryan"
      age 20
    end

    # Update the User's age
    my_user.edit do
      age 21
    end

The name of the class describes exactly what it will do. 
When the method `call` is called on `UserDSL`, it will delegate 
all of the given class's instance variables. Then it will `instance_eval` 
the given block to our `UserDSL`.

Check out the docs for examples. 
Each class defined has at least 1 example in the docs.

## Copyright

Copyright (c) 2010 Ryan Lewis. See LICENSE for details.