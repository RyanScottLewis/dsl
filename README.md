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
  
  class AttrDSL < DSL
    def_dsl_delegator :name, :age
  end
  
  def initialize(&blk)
    @dsl = AttrDSL.call(self, &blk)
  end
  
  def name=(value)
    @name = value.to_s.split(/\s+/).first.upcase
  end
  
  def age=(value)
    @age = value.to_i
  end
  
end

char = Character.new do
  name 'john doe'
  age '21'
end

char.name # => "JOHN"
char.age # => 21
```

## License

Copyright (c) 2010-2012 Ryan Lewis. See LICENSE for details.