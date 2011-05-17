# DSL ![](http://stillmaintained.com/c00lryguy/dsl.png)

## Description

dsl.rb is a small script to help create domain specific languages within Ruby.

### Notice

> Undergoing a complete overhaul.
> 
> Old code WILL BREAK.  
> Current code is UNSTABLE.  
> You've been warned.
Defining Methods/Arguments
==========================

You can define method within your DSL in a variety of ways:

    class MyDSL < DSL
      dsl_def :method1, :method2, :argument_for_both => "value"
      dsl_def :method3, :argument_for_just_method3 => "other_value"
    end

Arguments are defined by middleware. Without any middleware, any given arguments
mean nothing. This section is just showing of syntax.

You can also create methods using method_missing.
The above is exactly the same as the following:

    class MyDSL < DSL
      argument_for_both = "value"
      method1 :argument => argument_for_both
      method2 :argument => argument_for_both
      method3 :argument => "other_value"
    end

Or use blocks:

    class MyDSL < DSL
      dsl_def :method1, :method2 do
        argument "value"
      end
      
      method3 do
        argument "value"
      end
    end

Middleware
==========

Middleware can add functionality to your DSL by adding arguments when defining
DSL methods.

For example, when you use the DSL::Validate it adds the `validate` argument:

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

DSL::Validate allows you to validate the given arguments of your DSL method against
several types such as Regexp, Class, ect. You can see it's full functionality 
in the docs.

Using the above:

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

Wait what?
Well, right now you DSL only returns an instance of itself when called.
That works for debugging and whatnot, but we want to set the instance variable
@full_name within our User instance with the value set within the given DSL block
Lucklily, middleware saves the day! Middleware can override the return value
of the `call` class method of your DSL:

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

Cool. Let's set the instance variable.

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

You can see how this could easily get out of hand if you have an extensive DSL...
Middleware?
Middleware.

Middleware can let your DSL's `call` method accept arguments in the same way
as dsl_def. The DSL::DelegateInstanceVariables middleware uses this functionality.
Is also happens to be exactly what we need here.

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

Don't be afraid to combine middleware. They should all be able to work together
Some things to look out for:
* Middleware that set the same arguments. None of the middleware shipped with the gem do this. 
* Using multiple middleware that change the return value of your DSL's `call` method.
  The last given middleware that changes the result value will be returned.

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

But wait, theres more! If you call now, you can use your DSL as middleware!

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

--------------------------------------------------------------------------------

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

--------------------------------------------------------------------------------

    class WebApp
      class DirsDSL < DSL
        use DSL::LimitArguments
        use DSL::ReturnHash
        
        dsl_def :root, :static, :views do |meth|
          limit_args 1
          validate :class => String
          default do
            case meth
            when :root
              File.dirname(__FILE__)
            when :static
              File.join(File.dirname(__FILE__), "public")
            when :views
              File.join(File.dirname(__FILE__), "views")
            end
          end
        end
        
        on_method_missing do
          limit_args 1
          validate :class => String
        end
      end
      
      class ConfigureDSL < DSL
        use DSL::Validation
        use DSL::LimitArguments
        use DSL::RunDSL
        use DSL::DefaultValue
        use DSL::ReturnHash
        
        IP_REGEX = /\b(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\b/
        PORT_REGEX = /^(6553[0-5]|655[0-2]\d|65[0-4]\d\d|6[0-4]\d{3}|[1-5]\d{4}|[1-9]\d{0,3}|0)$/
        
        ip do
          limit_args 1
          validate :regex => IP_REGEX, :class => String
          default '0.0.0.0'
        end
        
        port do
          limit_args 1
          validate :regex => PORT_REGEX, :class => String
          default '1234'
        end
        
        server do
          validate :included_in => [:thin, :mongrel, :webrick]
          default :webrick
        end
        
        environment do
          validate :included_in => [:development, :testing, :production]
          default ENV['RACK_ENV'].to_sym || :development
        end
        
        dsl_def :enable, :disable do
          validate :included_in => [:sessions, :logging, :method_override, :static]
          
          if ENV['RACK_ENV'] == 'development'
            default [:sessions, :logging, :method_override, :static]
          else
            default []
          end
        end
        
        dirs do
          run_dsl DirsDSL
        end
      end
      
      class RoutesDSL < DSL
        use DSL::ReturnHash
        use DSL::LimitArguments
        use DSL::AcceptBlock
        
        dsl_def :get, :post, :put, :delete do
          limit_args 0
          accept_block
        end
      end
      
      class << self
        def config(&blk)
          if block_given?
            @config = ConfigureDSL.call(&blk)
          else
            @config
          end
        end
        
        def database(&blk)
          if block_given?
            @database = blk.call
          else
            @database
          end
        end
        
        def routes(&blk)
          if block_given?
            @routes = RoutesDSL.call(&blk)
          else
            @routes
          end
        end
        
        def call(env)
          
          env
        end
      end
    end

    class MyApp < WebApp
      config do
        ip "127.0.0.1"
        port "1234"
        server :thin, :mongrel
        enable :sessions, :logging, :method_override
        disable :static
        environment :development
        dirs do
          # These are the default values and the only predefined dirs
          root File.dirname(__FILE__)
          static 'public'
          views 'views'
          # Can define custom dirs here as well
          js File.join(static, 'js')
          images File.join(static, 'img')
        end
      end
      
      database do
        Sequel.sqlite("#{config.environment}.db")
      end
      
      routes do
        get '/' do
          haml :index
        end
      end
    end

config.ru

    require 'my_app'
    run MyApp

## Copyright

Copyright (c) 2010 Ryan Lewis. See LICENSE for details.
