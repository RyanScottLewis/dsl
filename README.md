# DSL ![](http://stillmaintained.com/c00lryguy/dsl.png)

## Description

dsl.rb is a small script to help create domain specific languages within Ruby.

### Notice

> Undergoing a complete overhaul.
> 
> Old code WILL BREAK. you have been warned.


## Install

`gem update --system` 

`gem update` 

`gem install dsl`

## Quick Example

    require 'dsl/import'

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

As you can see, simply requiring `dsl/import` adds the Module/Class method `dsl_method`, which defines a new instance method for your class that only accepts a block.

`dsl_method` only accepts a `Hash`, the key being the instance method name and the value being the DSL class the method will use.

When your DSL instance method is called (with a block, of course), all of your object's instance variables are delegated into a new instance of the DSL class assigned to the called DSL instance method.  
The block is then `instance_eval`'d within the new DSL class instance where you can use the instance variables.  
When the block is closed, all of the instance variables are then transfered back to your object.

Therefor, creating a Domain Specific Language is as easy as subclassing the `DSL` class. That's it!

## Use with any block:

To illustrate how to use with any block, The above example could be written like so:

    require 'dsl'

    class UserDSL < DSL
      def name(n);   @name = n;   end
      def gender(g); @gender = g; end
      def age(a);    @age = a;    end
    end

    class User
      attr :name, :gender, :age
      def edit(&blk)
        UserDSL.call(self, &blk)
      end
    end
    
The class method `call` takes a parent and a block. The parent that you give will get it's instance variables delegated to a new instance of your DSL class.

You could easily delegate instance variables from another class instance other than `self`

## Copyright

Copyright (c) 2010 Ryan Lewis. See LICENSE for details.
