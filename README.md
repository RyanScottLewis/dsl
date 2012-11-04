# DSL

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
  class AttributeDSL < DSL
    def_dsl :name, :age, :gender
  end
      
  attr_reader :name, :age, :gender
      
  def initialize(&blk)
    dsl = AttributeDSL.call(&blk)
        
    @name, @age, @gender = dsl.name, dsl.age, dsl.gender
    
    # OR:
    # @name, @age, @gender = dsl.to_h.values_at(:name, :age, :gender)
  end
end

Character.new do
  name 'John Doe'
  age 21
  gender :male
end
```

### Advanced

```ruby
class Character
  class AttributeDSL < DSL
    def_dsl :name do
      get do |value|
        value.split(' ').first.capitalize # Only return the first name, even if the person has a last name as well
      end
      
      set do |value| # The instance variable will be set to the result of this block
        raise 'name must be a String' unless value.respond_to?(:to_s)
        
        value.to_s
      end
    end
  end
  
  attr_reader :name
  
  def initialize(&blk)
    dsl = AttributeDSL.call(&blk)
        
    @name = dsl.name
    
    # OR:
    # @name, @age, @gender = dsl.to_h.values_at(:name, :age, :gender)
  end
end

Character.new do
  name 1234 # Error: name must be a String
end
```

## License

Copyright (c) 2010-2012 Ryan Lewis. See LICENSE for details.