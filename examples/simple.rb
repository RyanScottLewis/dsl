module DSL
  class Base; end

  class ReturnHash < Base
    # Define the result object for when you call this DSL
    result Hash.new
    # Same as: result { Hash.new }
    method_missing do |meth, *args, &blk|
      
    end
  end
end

class User

end