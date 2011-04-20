require 'dsl'

class Module
  def dsl_method(opts)
    raise(TypeError) unless opts.is_a?(Hash)
    # For each dsl_method, define it in the class
    # The methods do not accept arguments, only blocks
    opts.each do |method, dsl_class|
      define_method(method) do |&blk|
        raise(ArgumentError, "method #{method} requires a block") unless !!blk
        dsl_class.call(self, &blk)
      end
    end
  end
end
