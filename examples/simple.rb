# module DSL
#   class Base; end

#   class ReturnHash < Base
#     # Define the result object for when you call this DSL
#     result Hash.new
#     # Same as: result { Hash.new }
#     method_missing do |method, *args, &block|

#     end
#   end
# end

# class User

# end
# ========================================================================================
# ========================================================================================
# ========================================================================================
# ========================================================================================
# ========================================================================================
# ========================================================================================
# ========================================================================================

class User
  class UpdateDSL
    extend DSL::Base
    # Extend actually does the following
    #     include DSL::Global::InstanceMethods
    #     extend DSL::Global::ClassMethods
    #     extend DSL::Base::ClassMethods
    #
    # If you were to 'include DSL::Base', then the follow would happen:Base
    #     include DSL::Global::InstanceMethods
    #     extend DSL::Global::ClassMethods
    #     include DSL::Base::InstanceMethods

    dsl_def :name, :age do |meth, new_val|
      # instance_variable_set(meth, new_val) # Ugly, aliased as...
      set(meth, new_val)
    end

    # Same as:
    dsl_def :name { |new_val| @name = new_val }
    dsl_def :age { |new_val| @age = new_val }
  end

  attr :name, :age

  def update(&blk)
    UpdateDSL.call(&blk)
  end
end

my_user = User.new

my_user.update do
  name "Ryan"
  age 20
  foo :bar # => Error
end

# ========================================================================================
# ========================================================================================
# Now for Type checking..

class User
  class UpdateDSL
    extend DSL::TypeChecking

    dsl_def do
      name String
      date_of_birth Date, Time, String do |value|
        case value.class
        when Date or Time
          
        when String

        end
      end
    end
  end

  attr :name, :age

  def update(&blk)
    UpdateDSL.call(&blk)
  end
end

my_user = User.new

my_user.update do
  name "Ryan"
  age 20
  age "Twenty" # => Error
end