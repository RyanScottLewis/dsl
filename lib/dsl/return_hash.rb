$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'base'

# A DSL that returns all methods called within as a Hash.
# 
# @example
# result = DSL::ReturnHash.call do
#   foo "foo"
#   zig :zag
#   bar
#   hello "aloha", "namaste", "hallo"
#   i_have_a_block {
#     puts "Yay"
#   }
#   i_have_a_block_and_args "i really do!", :its_true {
#     puts "Yay"
#   }
# end
#
# p result # => {
#       :foo=>"foo", 
#       :zig=>:zag, 
#       :bar=>nil, 
#       :hello=>["aloha", "namaste", "hallo"],
#       :i_have_a_block=><#Proc:0x00>,
#       :i_have_a_block_and_args=>["i really do!", :its_true, <#Proc:0x00>],
#     }
module DSL
  class ReturnHash
    include Base

    def method_missing(meth, *args, &blk)
      @result = {}

      if args.empty?
        if block_given?
          @result[meth] = blk
        else
          @result[meth] = nil
        end
      else
        if args.length == 1
          if block_given?
            @result[meth] = [args.first, blk]
          else
            @result[meth] = args.first
          end
        else
          @result[meth] = args
          @result[meth] << blk if block_given?
        end
      end
    end
  end
end