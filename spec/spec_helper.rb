require 'pathname'
require 'dsl'
require 'bundler/setup'

Bundler.require(:development)

Dir[ Pathname.new(__FILE__).join('..', 'support', '**', '*').expand_path ].each { |filename| require filename }