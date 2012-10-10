require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'simplecov'
SimpleCov.command_name 'Unit Tests'
SimpleCov.start do
  add_filter "/test/" 
end

require 'test/unit'
require 'shoulda'

require 'thread'
require 'rails/all'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'wherewolf'

class TestApp < Rails::Application
  config.root = File.dirname(__FILE__)
end

Rails.application = TestApp
Wherewolf::Railtie.initializers.first.run(Rails.application)
ActiveRecord::Migration.verbose = false

class AddUsers < ActiveRecord::Migration
  def up
    create_table :players do |t|
      t.string :name
      t.string :position
      t.boolean :active
      t.date :first_cap
    end

    create_table :teams do |t|
      t.string :team
    end
  end

  def down
    drop_table :users
    drop_table :teams
  end
end

class Player < ActiveRecord::Base
  has_query_parsing 
end

class Team < ActiveRecord::Base
end

class Test::Unit::TestCase
end
