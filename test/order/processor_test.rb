require 'helper'

class OrderProcessorTest < Test::Unit::TestCase
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

  context 'OrderProcessor' do
    setup do
      setup_database
      setup_fixtures
    end
 
    should 'be a Wherewolf::Processor' do
      Wherewolf::Order::Processor.is_a?(Wherewolf::Processor)
    end

    context 'Parsing' do
      context 'Error' do
        should 'be raised is there is a parser error' do
          assert_raise Wherewolf::ParseError do
            Player.order_query('name up')
          end
        end

        should 'check that the column is in the list' do
          Wherewolf::Order::Processor.any_instance.expects(:check_column!).once
          Player.order_query('name asc')
        end
      end

      should 'construct an asc sort' do
        players = Player.order_query('name asc')
        assert_equal Player.order('name asc').all.map(&:name), players.all.map(&:name)
      end
      
      should 'construct an desc sort' do
        players = Player.order_query('name desc')
        assert_equal Player.order('name desc').all.map(&:name), players.all.map(&:name)
      end

      should 'default to asc' do
        players = Player.order_query('name')
        assert_equal Player.order('name asc').all.map(&:name), players.all.map(&:name)
      end

      should 'handle multiple sorts' do
        players = Player.order_query('name asc, position asc')
        assert_equal Player.order('name asc, position asc').all.map(&:name), players.all.map(&:name)
      end
    end
  end
end
