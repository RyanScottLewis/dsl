# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{dsl}
  s.version = "0.1.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["c00lryguy"]
  s.date = %q{2010-08-28}
  s.description = %q{A small library for creating Domain Specific Languages (DSLs)}
  s.email = %q{c00lryguy@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.md"
  ]
  s.files = [
    "LICENSE",
     "README.md",
     "Rakefile",
     "VERSION",
     "dsl.gemspec",
     "examples/database.rb",
     "examples/user.rb",
     "examples/webapp.rb",
     "lib/dsl.rb",
     "pkg/dsl-0.1.2.gem",
     "pkg/dsl-0.1.3.gem",
     "test/helper.rb",
     "test/test_dsl.rb"
  ]
  s.homepage = %q{http://github.com/c00lryguy/dsl}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{A small library for creating Domain Specific Languages (DSLs)}
  s.test_files = [
    "test/test_dsl.rb",
     "test/helper.rb",
     "examples/database.rb",
     "examples/user.rb",
     "examples/webapp.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<thoughtbot-shoulda>, [">= 0"])
    else
      s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
    end
  else
    s.add_dependency(%q<thoughtbot-shoulda>, [">= 0"])
  end
end

