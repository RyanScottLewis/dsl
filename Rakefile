require 'rake/version_task'
require 'rspec/core/rake_task'
require 'rubygems/package_task'
require 'pathname'

spec = Gem::Specification.new do |s|
  s.name         = 'dsl'
  s.version      = Pathname.new(__FILE__).dirname.join('VERSION').read.strip
  s.author       = 'Ryan Scott Lewis'
  s.email        = 'ryan@rynet.us'
  s.homepage     = "http://github.com/c00lryguy/#{s.name}"
  s.summary      = 'Helpers for the creation of Domain Specific Languages within your libraries and gems.'
  s.description  = 'Easily create DSLs for use within your projects!'
  s.require_path = 'lib'
  s.files        = `git ls-files`.lines.to_a.collect { |s| s.strip }
  s.executables  = `git ls-files -- bin/*`.lines.to_a.collect { |s| File.basename(s.strip) }
  
  s.post_install_message = "NOTICE!\n\n  DSL 0.2.x is INCOMPATIBLE with DSL 0.2.x!\n\n"
  
  s.add_dependency 'version', '~> 1.0.0'
  s.add_development_dependency 'rake', '~> 0.9'
  s.add_development_dependency 'guard-rspec', '~> 2.1.1'
  s.add_development_dependency 'fuubar', '~> 1.1'
  s.add_development_dependency 'at', '~> 0.1.2'
end

Rake::VersionTask.new do |t|
  t.with_git_tag = true
  t.with_gemspec = spec
end

RSpec::Core::RakeTask.new

Gem::PackageTask.new(spec) do |t|
  t.need_zip = false
  t.need_tar = false
end

task :default => :spec
