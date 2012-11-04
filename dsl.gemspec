# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "dsl"
  s.version = "0.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ryan Scott Lewis"]
  s.date = "2012-11-04"
  s.description = "Easily create DSLs for use within your projects!"
  s.email = "ryan@rynet.us"
  s.files = [".gitignore", ".rvmrc", "Gemfile", "Gemfile.lock", "Guardfile", "LICENSE", "README.md", "Rakefile", "VERSION", "dsl.gemspec", "lib/dsl.rb", "spec/dsl_spec.rb", "spec/spec_helper.rb", "spec/support/character_with_attr_reader.rb", "spec/support/character_with_attr_writer.rb", "spec/support/character_without_attributes.rb"]
  s.homepage = "http://github.com/c00lryguy/dsl"
  s.post_install_message = "NOTICE!\n\n  DSL 0.2.x is INCOMPATIBLE with DSL 0.2.x!\n\n"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.24"
  s.summary = "Helpers for the creation of Domain Specific Languages within your libraries and gems."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<version>, ["~> 1.0.0"])
      s.add_development_dependency(%q<rake>, ["~> 0.9"])
      s.add_development_dependency(%q<guard-rspec>, ["~> 2.1.1"])
      s.add_development_dependency(%q<fuubar>, ["~> 1.1"])
      s.add_development_dependency(%q<at>, ["~> 0.1.2"])
    else
      s.add_dependency(%q<version>, ["~> 1.0.0"])
      s.add_dependency(%q<rake>, ["~> 0.9"])
      s.add_dependency(%q<guard-rspec>, ["~> 2.1.1"])
      s.add_dependency(%q<fuubar>, ["~> 1.1"])
      s.add_dependency(%q<at>, ["~> 0.1.2"])
    end
  else
    s.add_dependency(%q<version>, ["~> 1.0.0"])
    s.add_dependency(%q<rake>, ["~> 0.9"])
    s.add_dependency(%q<guard-rspec>, ["~> 2.1.1"])
    s.add_dependency(%q<fuubar>, ["~> 1.1"])
    s.add_dependency(%q<at>, ["~> 0.1.2"])
  end
end
