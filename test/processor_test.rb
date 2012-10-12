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
          Wherewolf::Processor.new(Player).send(:check_column!, value, Player.arel_table)
        end
      end
    end

    context 'columns' do
      should 'return all the ARel table columns if options[:whitelist] and options[:blacklist] are not set' do
        assert_equal Player.arel_table.columns.map(&:name), Wherewolf::Processor.new(Player).send(:columns, Player.arel_table)
      end

      should 'return just the columns in the intersection of columns and whitelist if whitelist is set' do
        assert_equal [ :id, :name ], Wherewolf::Processor.new(Player, :whitelist => [ :not_in_column_set, :id, :name ]).send(:columns, Player.arel_table)
      end
      
      should 'return columns minus items in options[:blacklist] if options[:blacklist] is set' do
        assert_equal [ :name, :position, :active ], Wherewolf::Processor.new(Player, :blacklist => [ :id, :first_cap ]).send(:columns, Player.arel_table)
      end
    end

    context 'whitelist' do
      should 'return nil of options[:whitelist] is not set' do
        assert_equal nil, Wherewolf::Processor.new(Player).send(:whitelist)
      end
      
      should 'return options[:whitelist] if set' do
        assert_equal [ :name, :type ], Wherewolf::Processor.new(Player, :whitelist => [ :name, :type ]).send(:whitelist)
      end

      should 'evaluate options[:whitelist] if is a proc' do
        assert_equal [ :name, :type ], Wherewolf::Processor.new(Player, :whitelist => proc { return [ :name, :type ] }).send(:whitelist)
      end
    end
  
    context 'blacklist' do
      should 'return nil of options[:blacklist] is not set' do
        assert_equal nil, Wherewolf::Processor.new(Player).send(:blacklist)
      end
      
      should 'return options[:blacklist] if set' do
        assert_equal [ :name, :type ], Wherewolf::Processor.new(Player, :blacklist => [ :name, :type ]).send(:blacklist)
      end

      should 'evaluate options[:blacklist] if is a proc' do
        assert_equal [ :name, :type ], Wherewolf::Processor.new(Player, :blacklist => proc { return [ :name, :type ] }).send(:blacklist)
      end
    end
  end
end
