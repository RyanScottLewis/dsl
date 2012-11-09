# DSL [![Build Status](https://secure.travis-ci.org/c00lryguy/dsl.png)](http://travis-ci.org/c00lryguy/dsl)

## Description

Helpers for the creation of Domain Specific Languages within your libraries and gems.

## Install

### Bundler

`gem 'dsl'`

### RubyGems

`gem install dsl`

## Usage

### Simple

```ruby
class Character
  
  class AttrDSL < DSL
    def name(value=nil)
      @parent.name = value unless value.nil?
      
      @parent.name
    end
  end
  
  attr_reader :name
  
  def initialize(&blk)
    @dsl = AttrDSL.call(self, &blk)
  end
  
  def name=(value)
    @name = value.to_s.split(/\s+/).first.upcase
  end
  
end

char = Character.new do
  name 'john doe'
  p name # => "JOHN"
end

char.name # => "JOHN"
```

### DSL Delegator

```ruby
class Character
  
  class AttrDSL < DSL
    def_dsl_delegator :name, :age
  end
  
  def initialize(&blk)
    @dsl = AttrDSL.call(self, &blk)
  end
  
  attr_reader :name, :age
  
  def name=(value)
    @name = value.to_s.split(/\s+/).first.upcase
  end
  
  def age=(value)
    @age = value.to_i
  end
  
end

char = Character.new do
  name 'john doe'
  p name # => "JOHN"
  age '21'
  p age # => 21
end

char.name # => "JOHN"
char.age # => 21
```

`def_dsl_delegator` defines a method that accepts a variable number of arguments that will delegate to the parent.
This will attempt to call the setter/getter method before attempting to access the instance variable directly.

This way, any modifications you do to the instance variables in those methods will be used. Try adding a custom 
getter to the example above and you will get the expected outcome.

## License

Copyright (c) 2010-2012 Ryan Lewis. See LICENSE for details.