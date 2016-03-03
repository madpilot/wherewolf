# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: wherewolf 0.8.0 ruby lib

Gem::Specification.new do |s|
  s.name = "wherewolf"
  s.version = "0.8.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Myles Eftos"]
  s.date = "2016-03-03"
  s.description = "Wherewolf allows you to consume search terms as strings without worrying about database injections. It parses the query and converts it into ARel. It's great for creating filterable REST APIs."
  s.email = "myles@madpilot.com.au"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    ".document",
    ".travis.yml",
    "Gemfile",
    "Gemfile.lock",
    "Guardfile",
    "LICENSE.txt",
    "README.md",
    "Rakefile",
    "lib/wherewolf.rb",
    "lib/wherewolf/order/parser.rb",
    "lib/wherewolf/order/processor.rb",
    "lib/wherewolf/parse_error.rb",
    "lib/wherewolf/processor.rb",
    "lib/wherewolf/railtie.rb",
    "lib/wherewolf/where/parser.rb",
    "lib/wherewolf/where/processor.rb",
    "test/helper.rb",
    "test/order/parser_test.rb",
    "test/order/processor_test.rb",
    "test/parse_error_test.rb",
    "test/processor_test.rb",
    "test/railtie_test.rb",
    "test/where/parser_test.rb",
    "test/where/processor_test.rb",
    "wherewolf.gemspec"
  ]
  s.homepage = "http://github.com/madpilot/wherewolf"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.6"
  s.summary = "Makes filtering and searching to your REST API crazy easy."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<arel>, [">= 0"])
      s.add_runtime_dependency(%q<parslet>, [">= 0"])
      s.add_development_dependency(%q<simplecov>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<rdoc>, [">= 0"])
      s.add_development_dependency(%q<guard>, [">= 0"])
      s.add_development_dependency(%q<guard-test>, [">= 0"])
    else
      s.add_dependency(%q<arel>, [">= 0"])
      s.add_dependency(%q<parslet>, [">= 0"])
      s.add_dependency(%q<simplecov>, [">= 0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<rdoc>, [">= 0"])
      s.add_dependency(%q<guard>, [">= 0"])
      s.add_dependency(%q<guard-test>, [">= 0"])
    end
  else
    s.add_dependency(%q<arel>, [">= 0"])
    s.add_dependency(%q<parslet>, [">= 0"])
    s.add_dependency(%q<simplecov>, [">= 0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<rdoc>, [">= 0"])
    s.add_dependency(%q<guard>, [">= 0"])
    s.add_dependency(%q<guard-test>, [">= 0"])
  end
end

