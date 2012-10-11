require 'helper'

class WhereProcessorTest < Test::Unit::TestCase
  context 'WhereProcessor' do
    setup do
      setup_database
      setup_fixtures
    end
  
    should 'be a Wherewolf::Processor' do
      Wherewolf::Where::Processor.is_a?(Wherewolf::Processor)
    end
    
    context 'Parsing' do
      context 'Error' do
        should 'be raised is there is a parser error' do
          assert_raise Wherewolf::ParseError do
            Player.where_query('name ~= "Patrick%" || (position = "fail)')
          end
        end

        should 'allow retrieval of the error position' do
          begin
            Player.where_query('name ~= "Patrick%" || (position = "fail)')
          rescue Wherewolf::ParseError => e
            assert_equal 28, e.position
          end
        end

        should 'show a nice debug error' do
          begin
            Player.where_query('name ~= "Patrick%" || (position = "fail)')
          rescue Wherewolf::ParseError => e
            assert_equal "Parsing error occured at character 28", e.error_message
          end
        end
      
        should 'to_s should print out nice error' do
          begin
            Player.where_query('name ~= "Patrick%" || (position = "fail)')
          rescue Wherewolf::ParseError => e
            assert_equal "Parsing error occured at character 28", e.to_s
          end
        end
        
        should 'be raised if the requested column is not in the list' do
          assert_raise Wherewolf::ParseError do
            Player.where_query('shoe_size > 10')
          end
        end

        should 'check to see if the column is allowed' do
          Wherewolf::Where::Processor.any_instance.expects(:check_column!).once
          begin
            Player.where_query('shoe_size > 10')
          rescue Wherewolf::ParseError => e
            assert_equal "Parsing error occured at character 0", e.to_s
          end
        end
      end

      should 'construct simple boolean statements' do
        player = Player.where_query('name = "Charlie Ellis"')
        assert_equal 1, player.count
        assert_equal 'Charlie Ellis', player.first.name
      end

      should 'construct two boolean statments' do
        player = Player.where_query('position=lock && first_cap < 2010-01-01')
        assert_equal 1, player.count
        assert_equal "Patrick 'Paddy' Carew", player.first.name
      end

      should 'contruct nested brackets' do
        player = Player.where_query("(position = wing || position = lock) && first_cap <= 1905-01-01").order('first_cap')
        assert_equal 3, player.count
        assert_equal "Patrick 'Paddy' Carew", player[0].name
        assert_equal "Syd Miller", player[1].name
        assert_equal "Charlie Redwood", player[2].name
      end

      should 'handle matches' do
        player = Player.where_query('name ~= "James%"')
        assert_equal 1, player.count
        assert_equal "James Slipper", player.first.name
      end

      should 'handle nulls' do
        player = Player.where_query("first_cap = null")
        assert_equal 1, player.count
        assert_equal "James Slipper", player.first.name
      end

      should 'handle booleans' do
        player = Player.where_query("active = true")
        assert_equal 2, player.count
        player = Player.where_query("active = false")
        assert_equal 8, player.count
      end

      should 'handle dates' do
        player = Player.where_query("first_cap > 2000-01-01")
        assert_equal 1, player.count
        assert_equal "Salesi Ma'afu", player.first.name
      end

      should 'process =' do
        player = Player.where_query('name = "Charlie Ellis"')
        assert_equal 1, player.count
        assert_equal 'Charlie Ellis', player.first.name
      end
      
      should 'process !=' do
        player = Player.where_query('name != "Charlie Ellis"')
        assert_equal 9, player.count
        assert_equal false, player.map(&:name).include?('Charlie Ellis')
      end
      
      should 'process >' do
        player = Player.where_query('first_cap > 1907-08-03')
        assert_equal 1, player.count
      end
      
      should 'process >=' do
        player = Player.where_query('first_cap >= 1907-08-03')
        assert_equal 2, player.count
      end

      should 'process <' do
        player = Player.where_query('first_cap < 1907-08-03')
        assert_equal 7, player.count
      end
      
      should 'process <=' do
        player = Player.where_query('first_cap <= 1907-08-03')
        assert_equal 8, player.count
      end
    end
  end
end
