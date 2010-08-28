#!/usr/bin/env ruby

require 'dsl'
require 'pp'

class ToDoList
  class DSL < ::DSL
    def high(task);   @list[:high] << task;   end
    def medium(task); @list[:medium] << task; end
    def low(task);    @list[:low] << task;    end
  end
  
  def initialize
    @list = { :high => [], :medium => [], :low => [] }
  end
end

def to(&blk)
  ToDoList::DSL.call(ToDoList.new, &blk)
end

my_todo_list = to do
  high "feed the dog"
  medium "change pants because of stain"
  low "sneeze"
  high "kill parents for insurence money"
  low "change flickering light"
  medium "eat"
  low "shave"
end

pp my_todo_list

=begin 
 => #<ToDoList:0x00000002699280
     @list=
      {:high=>["feed the dog", "kill parents for insurence money"],
       :medium=>["change pants because of stain", "eat"],
       :low=>["sneeze", "change flickering light", "shave"]}>
=end
