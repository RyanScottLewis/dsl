# DSL

## Description

dsl.rb is a small script (26 lines) to help create domain specific languages within Ruby.

## Install

Until I setup the gem... just clone and play around with it.

## Quick Example

    require 'dsl'

    class UserDSL < DSL
      def name(n);   @name = n;   end
      def gender(g); @gender = g; end
      def age(a);    @age = a;    end
    end

    class User
      attr :name, :gender, :age
      dsl_method :edit => UserDSL
    end

    ryguy = User.new

    ryguy.edit do
      name 'Ryan Lewis'
      gender :male
      age 19
    end

    p ryguy
    # => #<User:0x00000001b6dc78 @name="Ryan Lewis", @gender=:male, @age=19>

As you can see, simply requiring DSL adds the Module/Class method `dsl_method`, which defines a new instance method for your class that only accepts a block.

`dsl_method` only accepts a `Hash`, the key being the instance method name and the value being the DSL class the method will use.

When your DSL instance method is called (with a block, of course), all of your object's instance variables are delegated into a new instance of the DSL class assigned to the called DSL instance method.  
The block is then `instance_eval`'d within the new DSL class instance where you can use the instance variables.  
When the block is closed, all of the instance variables are then transfered back to your object.

Therefor, creating a Domain Specific Language is as easy as subclassing the `DSL` class. That's it!

## Copyright

Copyright (c) 2010 Ryan Lewis. See LICENSE for details.
