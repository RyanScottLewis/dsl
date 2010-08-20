#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), '..', 'dsl')

class Database
  class Table
    def initialize
      @schema = {}
      @entries = []
    end
    
    def create(opts)
      raise(TypeError) unless opts.is_a?(Hash)
      opts.each do |name, v|
        raise("key '#{name}' not defined in schema") unless @schema.has_key?(name)
        if @schema[name] == :primary_key
          raise('You cannot set primary keys')
        else
          raise("key '#{name}' not of type #{@schema[name]}") unless v.is_a?(@schema[name])
        end
      end
      @schema.select { |name, v| v == :primary_key }.each do |name, v|
        opts[name] = @entries.count
      end
      @entries << opts
    end
    
    def [](id)
      @entries.find_all do |entry|
        entry[:id] == id
      end
    end
  end
  
  class SchemaDSL < DSL
    def primary_key(name); @schema[name] = :primary_key; end
    def String(name);      @schema[name] = ::String;     end
    def Integer(name);     @schema[name] = ::Integer;    end
  end
  
  def initialize
    @tables = {}
  end
  
  def table(name, &blk)
    if block_given?
      raise("Table '#{name}' already exists") unless @tables[name].nil?
      @tables[name] = Table.new
      SchemaDSL.call(@tables[name], &blk)
    else
      @tables[name]
    end
  end
end

require 'ap'

db = Database.new

db.table(:users) do
  primary_key :id
       String :username
      Integer :age
end

db.table(:users).create(:username => 'Foo', :age => 19)
db.table(:users).create(:username => 'Bar', :age => 43)

p db.table(:users)[0]
# => [{:username=>"Foo", :age=>19, :id=>0}]

p db.table(:users)[1]
# => [{:username=>"Bar", :age=>43, :id=>1}]

db.table(:users).create(:username => 'Baz', :age => 'One Hundred')
# => ERROR: key 'age' not of type Integer (RuntimeError)

