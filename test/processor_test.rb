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
    Player.create!(:name => "Patrick 'Paddy' Carew", :position => 'lock', :first_cap => '1899-06-24')
    Player.create!(:name => "Charlie Ellis", :position => 'flanker', :first_cap => '1899-06-24')
    Player.create!(:name => "Arthur Corfe", :position => 'flanker', :first_cap => '1899-07-22')
    Player.create!(:name => "Syd Miller", :position => 'wing', :first_cap => '1899-08-05')
    Player.create!(:name => "Charlie Redwood", :position => 'wing', :first_cap => '1903-08-15')
    Player.create!(:name => "Patrick 'Pat' Walsh", :position => 'no. 8', :first_cap => '1904-07-02')
    Player.create!(:name => "John Manning", :position => 'fly-half', :first_cap => '1904-07-23')
    Player.create!(:name => "Dally Messenger", :position => 'wing', :first_cap => '1907-08-03')
    Player.create!(:name => "Herbert Moran", :position => 'flanker', :first_cap => '1908-12-12')
    Player.create!(:name => "Alfred Walker", :position => 'scrum-half', :first_cap => '1912-11-16')
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
        player = Player.parse('position = "Charlie Ellis"')
        assert_equal 1, player.count
        assert_equal 'Charlie Ellis', player.first.name
      end
    end
  end
end
