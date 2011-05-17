#!/usr/bin/env ruby

module DSL
end

$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'dsl/return_hash'
require 'dsl/delegate_instance_variables'
