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
    extend ReturnsResult

    def method_missing(meth, *args, &blk)
      @result ||= {}
      @result = {} unless @result.is_a?(Hash)

      if args.empty?
        @result[meth] = block_given? ? blk : nil
      elsif args.length == 1
        @result[meth] = block_given? ? args << blk : args.first
      else
        @result[meth] = block_given? ? args << blk : args
      end
    end
  end
end

require 'pp'

result = DSL::ReturnHash.call do
  foo "foo"
  zig :zag
  bar
  hello "aloha", "namaste", "hallo"
  i_have_a_block {
    puts "Yay"
  }
  i_have_a_block_and_args("i really do!", :its_true) {
    puts "Yay"
  }
end

pp result
# {:foo=>"foo",
#  :zig=>:zag,
#  :bar=>nil,
#  :hello=>["aloha", "namaste", "hallo"],
#  :i_have_a_block=>
#   #<Proc:0x0000>,
#  :i_have_a_block_and_args=>
#   ["i really do!",
#    :its_true,
#    #<Proc:0x0000>],
#  :remove_instance_variable=>:@result}