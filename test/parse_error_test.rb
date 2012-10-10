require 'helper'

class ParseErrorTest < Test::Unit::TestCase
  context 'ParseError' do
    should 'be a child of Parslet::ParseFailed' do
      Wherewolf::ParseError.is_a?(Parslet::ParseFailed)
    end
  end
end
