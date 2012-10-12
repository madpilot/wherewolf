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
require 'mocha'

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
    
    create_table :countries do |t|
      t.string :name
      t.string :jersey_color
    end
  end

  def down
    drop_table :users
    drop_table :teams
    drop_table :countries
  end
end

class Player < ActiveRecord::Base
  has_query_parsing 
end

class Team < ActiveRecord::Base
end

class Country < ActiveRecord::Base
  attr_accessible :name
  has_query_parsing :whitelist => [ :name ]
end

class Test::Unit::TestCase
  def setup_fixtures
    Player.create!(:name => "Patrick 'Paddy' Carew", :position => 'lock', :first_cap => '1899-06-24', :active => false)
    Player.create!(:name => "Charlie Ellis", :position => 'flanker', :first_cap => '1899-06-24', :active => false)
    Player.create!(:name => "Arthur Corfe", :position => 'flanker', :first_cap => '1899-07-22', :active => false)
    Player.create!(:name => "Syd Miller", :position => 'wing', :first_cap => '1899-08-05', :active => false)
    Player.create!(:name => "Charlie Redwood", :position => 'wing', :first_cap => '1903-08-15', :active => false)
    Player.create!(:name => "Patrick 'Pat' Walsh", :position => 'no. 8', :first_cap => '1904-07-02', :active => false)
    Player.create!(:name => "John Manning", :position => 'fly-half', :first_cap => '1904-07-23', :active => false)
    Player.create!(:name => "Dally Messenger", :position => 'wing', :first_cap => '1907-08-03', :active => false)
    Player.create!(:name => "Salesi Ma'afu", :position => 'prop', :first_cap => '2010-06-05', :active => true)
    Player.create!(:name => "James Slipper", :position => 'prop', :first_cap => nil, :active => true)
  end

  def setup_database
    ActiveRecord::Base.establish_connection({
      :adapter => 'sqlite3',
      :database => ':memory:',
      :verbosity => 'quiet'
    })
    Arel::Table.engine = Arel::Sql::Engine.new(ActiveRecord::Base)
    AddUsers.migrate(:up)
  end
end
