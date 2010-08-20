#!/usr/bin/env ruby

require File.join(File.dirname(__FILE__), '..', 'dsl')

class ConfigDSL < DSL
  def add_helpers(*h)
    @helpers.concat(h)
  end
end

class WebApp
  attr :helpers
  dsl_method :config => ConfigDSL
  
  #===--- OR:
  # dsl_method :config => Class.new(DSL) {
  #   def add_helpers(*h)
  #     @helpers.concat(h)
  #   end
  # }
  
  #===--- MAYBE:
  # define_dsl_method :config do
  #   def add_helpers; end
  # end
  
  def initialize
    @helpers = ['helpers/foo', 'helpers/bar']
  end
end

web_app = WebApp.new

p web_app.helpers
# => ["helpers/foo", "helpers/bar"]

web_app.config do
  add_helpers 'helpers/baz', 'helpers/qux'
end

p web_app.helpers
# => ["helpers/foo", "helpers/bar", "helpers/baz", "helpers/qux"]

