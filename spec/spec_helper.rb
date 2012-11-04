require 'pathname'
require 'dsl'

Bundler.require(:development)

Dir[ Pathname.new(__FILE__).join('..', 'support', '**', '*').expand_path ].each { |filename| require filename }