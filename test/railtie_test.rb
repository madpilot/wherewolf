require 'helper'

class RailtieTest < Test::Unit::TestCase
  context 'Railtie' do
    should 'not enable where_query if has_query_parsing is not called' do
      assert_equal false, Team.respond_to?(:where_query)
    end
    
    should 'enable where_query if has_query_parsing is called' do
      assert_equal true, Player.respond_to?(:where_query)
    end
  end
end
