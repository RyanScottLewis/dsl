# The DSL gem implements "middleware" much like Rack

class DSL
  class << self
    def use(middleware, *args, &blk)
    
    end
    
    def dsl_def(*meths, args={}, &blk)
    
    end
    
    def call(*args, &blk)
    
    end
    
    def method_missing(meth, *args, &blk)
    
    end
    
    
    
    def on_call(&blk)
      (@on_call_blocks ||= []) << blk
    end
    
    def on_method_missing(&blk)
      (@on_method_missing_blocks ||= []) << blk
    end
    
  end
end

#==============================================================================#
#= Defining Methods/Arguments =================================================#
#==============================================================================#

# You can define method within your DSL in a variety of ways:

class MyDSL < DSL
  dsl_def :method1, :method2, :argument_for_both => "value"
  dsl_def :method3, :argument_for_just_method3 => "other_value"
end

# Arguments are defined by middleware. Without any middleware, any given arguments
# mean nothing. This section is just showing of syntax.

# You can also create methods using method_missing.
# The above is exactly the same as the following:

class MyDSL < DSL
  argument_for_both = "value"
  method1 :argument => argument_for_both
  method2 :argument => argument_for_both
  method3 :argument => "other_value"
end

# Or use blocks:

class MyDSL < DSL
  dsl_def :method1, :method2 do
    argument "value"
  end
  
  method3 do
    argument "value"
  end
end

#==============================================================================#
#= Middleware =================================================================#
#==============================================================================#

# Middleware can add functionality to your DSL by adding arguments when defining
# DSL methods.
#
# For example, when you use the DSL::Validate it adds the `validate` argument:

class MyDSL < DSL
  use DSL::Validate
  
  dsl_def :full_name, :validate => { :regex => /^\w+ \w+$/ }
  # Or:
  dsl_def :full_name do
    validate :regex => /^\w+ \w+$/
  end
  # Or:
  dsl_def :full_name do
    validate do 
      regex /^\w+ \w+$/
    end
  end
  # Or: 
  full_name do
    validate do 
      regex /^\w+ \w+$/
    end
  end
  # Or any variation thereof
end

# DSL::Validate allows you to validate the given arguments of your DSL method against
# several types such as Regexp, Class, ect. You can see it's full functionality 
# in the docs.
# 
# Using the above:

class User
  def initialize(full_name=nil)
    @full_name = full_name
  end
  
  def edit(&blk)
    MyDSL.call(&blk)
  end
end

#===---

user = User.new 
result = user.edit do
  full_name "Jack Johnson"
end
p result # => #<DSL:0x0000>

# Wait what?
# Well, right now you DSL only returns an instance of itself when called.
# That works for debugging and whatnot, but we want to set the instance variable
# @full_name within our User instance with the value set within the given DSL block
# Lucklily, middleware saves the day! Middleware can override the return value
# of the `call` class method of your DSL:

class MyDSL < DSL
  use DSL::Validate
  # If a middleware changes the return value of your DSL, it's name will probably
  # start with "Return" or "Returns". This isn't always the case, though.
  use DSL::ReturnHash
  
  full_name do
    validate :regex => /^\w+ \w+$/
  end
end

class User
  def initialize(full_name=nil)
    @full_name = full_name
  end
  
  def edit(&blk)
    MyDSL.call(&blk)
  end
end

#===---

user = User.new 
result = user.edit do
  full_name "Jack Johnson"
end
p result # => { :full_name => "Jack Johnson" }

# Cool. Let's set the instance variable.

class User
  def initialize(full_name=nil)
    @full_name = full_name
  end
  
  def edit(&blk)
    result = MyDSL.call(&blk)
    @full_name = result[:full_name]
  end
end

#===---

user = User.new 
user.edit do
  full_name "Jack Johnson"
end
p user # => #<User:0x0000 @full_name="Jack Johnson">

# You can see how this could easily get out of hand if you have an extensive DSL...
# Middleware?
# Middleware.
# 
# Middleware can let your DSL's `call` method accept arguments in the same way
# as dsl_def. The DSL::DelegateInstanceVariables middleware uses this functionality.
# Is also happens to be exactly what we need here.

class MyDSL < DSL
  use DSL::Validate
  use DSL::DelegateInstanceVariables
  
  full_name do
    validate :regex => /^\w+ \w+$/
  end
end

class User
  def initialize(full_name=nil)
    @full_name = full_name
  end
  
  def edit(&blk)
    # DSL::DelegateInstanceVariables has added the `:parent` argument
    MyDSL.call(&blk, :parent => self)
    # Or:
    MyDSL.call(&blk) do
      parent self
    end 
  end
end

#===---

user = User.new 
user.edit do
  full_name "Jack Johnson"
end
p user # => #<User:0x0000 @full_name="Jack Johnson">

# Don't be afraid to combine middleware. They should all be able to work together
# Some things to look out for:
# * Middleware that set the same arguments. None of the middleware shipped with the gem do this. 
# * Using multiple middleware that change the return value of your DSL's `call` method.
#   The last given middleware that changes the result value will be returned.

class MyDSL < DSL
  use DSL::Validate
  use DSL::ReturnHash
  use DSL::DelegateInstanceVariables
  
  full_name do
    validate :regex => /^\w+ \w+$/
  end
end

class User
  def initialize(full_name=nil)
    @full_name = full_name
  end
  
  def edit(&blk)
    result = MyDSL.call(&blk, :parent => self)
    puts "@full_name was set to #{result[:full_name]}"
  end
end

#===---

user = User.new 
user.edit do
  full_name "Jack Johnson"
end
p user # => #<User:0x0000 @full_name="Jack Johnson">

# But wait, theres more! If you call now, you can use your DSL as middleware!

class MyMagicDSL < DSL
  use DSL::Validate
  use DSL::ReturnHash
  use DSL::DelegateInstanceVariables
end

class MyDSL < DSL
  use DSL::MyMagicDSL
  
  full_name do
    validate :regex => /^\w+ \w+$/
  end
end

#===============================================================================
#===============================================================================
#===============================================================================

class Character
  class StatsDSL < DSL
    use DSL::Validate
    use DSL::LimitArguments
    use DSL::ReturnHash
    
    dsl_def :speed, :strength, :stealth do
      limit_args 1
      validate :class => Integer
    end
  end
  
  class InitDSL < DSL
    use DSL::Validate
    use DSL::LimitArguments
    use DSL::RunDSL
    use DSL::DelegateInstanceVariables
    
    dsl_def :name, :bio do
      limit_args 1 # Only alow 1 arg
      validate :class => String
    end
    
    age do
      limit_args 1
      validate :class => [Integer, Float] # Why not float, just for the sake of this example?
    end
    
    stats do
      limit_args 1
      # This runs the given block with the StatsDSL
      # It also allows for a Hash to be given as an argument instead
      # of a block, just like middleware!
      run_dsl StatsDSL
    end
  end
end

class Character
  def initialize(&blk)
    InitDSL.call(self, &blk)
  end
end

#===---

my_char = Character.new do
  name "Gandolf"
  bio "The old guy from LotR"
  age 32045
  stats do
    speed 45
    strength 34
    stealth 60
  end
  # Or:
  stats :speed => 45, :strength => 34, :stealth => 60
end

# outputs:
#   #<Character:0x00 
#     @name = "Gandolf"
#     @bio = "The old guy from LotR"
#     @age = 32045
#     @stats = {
#       :speed => 45,
#       :strength => 34,
#       :stealth => 60
#     }
#   >

#===============================================================================
#===============================================================================
#===============================================================================

class WebApp
  class ConfigureDSL < DSL
    use DSL::Validation
    use DSL::LimitArguments
    
    ip do
      validate :regex => //
    end
  end
  
  class << self
    def config(&blk)
      if block_given?
        
      else
        @config
      end
    end
  end
end

class MyApp < WebApp
  config do
    ip "127.0.0.1"
    port "1234"
    server :thin, :mongrel, 'webrick'
    enable :sessions, :logging, :method_override
    environment :development
    dirs do
      # These are the default values and the only predefined dirs
      root File.dirname(__FILE__)
      static 'public'
      views 'views'
      # Can define custom dirs here as well
      js File.join(static, 'js')
      images File.join(statis, 'img')
    end
  end
  
  database do
    Sequel.sqlite("#{config.environment}.db")
  end
  # Same as:
  #   database Sequel.sqlite("#{config.environment}.db")
  
  routes do
    get '/' do
      haml :index
    end
  end
end
