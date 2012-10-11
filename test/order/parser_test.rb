require 'helper'

class OrderParserTest < Test::Unit::TestCase
  context 'OrderParser' do
    setup do
      @parser = Wherewolf::Order::Parser.new
    end

    context "operands" do
      should 'parse column name' do
        result = @parser.parse('name')
        assert_equal({ :column => "name", :direction => nil }, result)
      end

      should 'parse column with desc' do
        result = @parser.parse('name desc')
        assert_equal({ :column => "name", :direction => "desc" }, result)
      end

      should 'parse column with asc' do
        result = @parser.parse('name asc')
        assert_equal({ :column => "name", :direction => "asc" }, result)
      end
      
      should 'parse multiple comma seperated order expressions' do
        result = @parser.parse('name asc, age desc')
        assert_equal([ { :column => "name", :direction => "asc" }, { :column => "age", :direction => "desc" } ], result)
      end
    end
  end
end
