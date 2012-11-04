require 'pathname'

__LIB__ = Pathname.new(__FILE__).join('..', '..', 'lib').expand_path
$:.unshift(__LIB__.to_s) unless $:.include?(__LIB__.to_s)

require 'dsl'
require 'bundler/setup'

Bundler.require(:development)

Dir[ Pathname.new(__FILE__).join('..', 'support', '**', '*').expand_path ].each { |filename| require filename }