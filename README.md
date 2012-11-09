# DSL [![Build Status](https://secure.travis-ci.org/c00lryguy/dsl.png)](http://travis-ci.org/c00lryguy/dsl)

## Description

Helpers for the creation of Domain Specific Languages within your libraries and gems.

## Install

### Bundler: `gem 'dsl'`

### RubyGems: `gem install dsl`

## Usage

### DSL.call

#### Simple

> From the docs:

If the last argument is not a Hash, then the *first* argument will be defined as `@parent` on the DSL instance.  
All other arguments will be passed to the `initialize` method of the DSL instance.

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
    AttrDSL.call(self, &blk)
  end
  
  def name=(value)
    @name = value.to_s.split(/\s+/).first.upcase
  end
  
end

char = Character.new do
  name 'john doe'
end

char.name # => "JOHN"
```

#### Advanced

> From the docs:

If the last argument is a `Hash`, the keys will be transformed into an `underscore`'d String, then into a `Symbol`.  
If the key does not start with an "at" (`@`) character, we will prepend one to it.  
This means you can set class variables as well by using `:@@class_iv`, and `:foo` and `:@foo` are equivalent.  
Each key is then defined as an instance variable on the `DSL` instance with the object given as the value.  
All other arguments will be passed to the `initialize` method of the `DSL` instance.

```ruby
class Character
  
  class AttrDSL < DSL
    def name(value=nil)
      @character.name = value unless value.nil?
      
      @character.name
    end
  end
  
  attr_reader :name
  
  def initialize(&blk)
    AttrDSL.call(character: self, &blk)
  end
  
  def name=(value)
    @name = value.to_s.split(/\s+/).first.upcase
  end
  
end

char = Character.new do
  name 'john doe'
end

char.name # => "JOHN"
```

### DSL Delegator

#### Simple

Defines a method that accepts a variable number of arguments that will delegate to the parent.  
This will attempt to call the setter/getter method before attempting to access the instance variable.  
This way, any modifications you do to the instance variables in those methods will be used.

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
  age '21'
end

char.name # => "JOHN"
char.age # => 21
```

#### Advanced

When combined with the "Advanced" usage of `DSL.call`, you can easily create a very powerful DSL:

```ruby
class Character
  
  class Stats
    def speed
      @speed ||= 10
    end
    
    def strength
      @strength ||= 10
    end
    
    def speed=(value)
      @speed = value.to_i
    end
    
    def strength=(value)
      @strength = value.to_i
    end
  end
  
  class DSL < ::DSL
    def_dsl_delegator :@character, :name, :age
    def_dsl_delegator :@stats, :speed, :strength
  end
  
  attr_reader :name, :age
  
  def initialize(&blk)
    @stats = Stats.new
    
    update(&blk) if block_given?
  end
  
  def update(&blk)
    DSL.call(character: self, stats: @stats, &blk)
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
  speed :15
  strength 50.2
end

char.name # => "JOHN"
char.age # => 21
char.stats.speed # => 15
char.stats.strength # => 50
```

## License

Copyright (c) 2010-2012 Ryan Lewis. See LICENSE for details.