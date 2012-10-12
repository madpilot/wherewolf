# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'

Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "wherewolf"
  gem.homepage = "http://github.com/madpilot/wherewolf"
  gem.license = "MIT"
  gem.summary = %Q{Makes filtering and searching to your REST API crazy easy.}
  gem.description = %Q{Wherewolf allows you to consume search terms as strings without worrying about database injections. It parses the query and converts it into ARel. It's great for creating filterable REST APIs.}
  gem.email = "myles@madpilot.com.au"
  gem.authors = ["Myles Eftos"]
  gem.version = "0.4.1"
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

task :default => :test

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "wherewolf #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
