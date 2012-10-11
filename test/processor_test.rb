require 'helper'

class ProcessorTest < Test::Unit::TestCase
  context 'WhereProcessor' do
    setup do
      setup_database
      setup_fixtures
    end
  
    context 'check_column!' do
      should 'raise a ParseError if column is not in the mode' do
        value = mock
        value.stubs(:to_sym).returns(:show_size)
        value.stubs(:to_s).returns('show_size')
        value.stubs(:offset).returns(0)
        assert_raise Parslet::ParseFailed do
          Wherewolf::Processor.new.send(:check_column!, value, Player.arel_table)
        end
      end
    end
  end
end
