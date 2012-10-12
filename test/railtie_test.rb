require 'helper'

class RailtieTest < Test::Unit::TestCase
  context 'Railtie' do
    setup do
      setup_database
      setup_fixtures
    end
    
    should 'not enable where_query if has_query_parsing is not called' do
      assert_equal false, Team.respond_to?(:where_query)
    end
    
    should 'enable where_query if has_query_parsing is called' do
      assert_equal true, Player.respond_to?(:where_query)
    end
  
    should 'not enable order_query if has_query_parsing is not called' do
      assert_equal false, Team.respond_to?(:order_query)
    end
    
    should 'enable order_query if has_query_parsing is called' do
      assert_equal true, Player.respond_to?(:order_query)
    end

    should 'allow where_query and order_query to be nestable' do
      assert_nothing_raised do
        players = Player.where_query('active = true').order_query('name desc')
        assert_equal Player.where('active = ?', true).order('name desc').map(&:id), players.map(&:id)
      end
    end
  end
end
