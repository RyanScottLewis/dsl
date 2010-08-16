#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), '..', 'dsl')

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
