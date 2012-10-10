require 'helper'
require 'thread'
require 'active_record'
require 'arel'

ActiveRecord::Migration.verbose = false

class AddUsers < ActiveRecord::Migration
  def up
    create_table :players do |t|
      t.string :name
      t.string :position
      t.boolean :active
      t.date :first_cap
    end
  end

  def down
    drop_table :users
  end
end

class Player < ActiveRecord::Base
  include Wherewolf # Rails will use a Railtie, but we'll test that elsewehere
  has_query_parsing 
end

class ProcessorTest < Test::Unit::TestCase
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
    Player.create!(:name => "James Slipper", :position => 'prop', :first_cap => '2010-06-12', :active => true)
  end

  context 'Processor' do
    setup do
      ActiveRecord::Base.establish_connection({
        :adapter => 'sqlite3',
        :database => ':memory:',
        :verbosity => 'quiet'
      })
      Arel::Table.engine = Arel::Sql::Engine.new(ActiveRecord::Base)
      AddUsers.migrate(:up)
      setup_fixtures
    end
  
    context 'Parsing' do
      should 'construct simple boolean statements' do
        player = Player.parse('name = "Charlie Ellis"')
        assert_equal 1, player.count
        assert_equal 'Charlie Ellis', player.first.name
      end
    end
  end
end
