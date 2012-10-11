require 'parslet'

module Wherewolf
  module Order
    class Parser < Parslet::Parser
      rule(:space) { match('\s').repeat(1) }
      rule(:space?) { space.maybe }
      rule(:comma) { str(',') >> space? }
      
      rule(:literal) { match('[a-zA-Z0-9\-_]').repeat(1).as(:column) >> space? }
      rule(:direction) { str('asc') | str('desc') }

      rule(:order) { literal >> direction.maybe.as(:direction) }
      rule(:multiple) { order >> (comma >> order).repeat }
      rule(:expression) { multiple | order }
      
      root :expression
    end
  end
end
