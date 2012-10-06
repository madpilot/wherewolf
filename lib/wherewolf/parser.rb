require 'parslet'

module Wherewolf
  class Parser < Parslet::Parser  
    rule(:space) { match('\s').repeat(1) }
    rule(:space?) { space.maybe }
    rule(:left_parenthesis) { str('(') }
    rule(:right_parenthesis) { str(')') }

    # Comparisons
    rule(:eq) { str('=') }
    rule(:not_eq) { str('!=') }
    rule(:lt) { str('<') }
    rule(:lteq) { str('<=') }
    rule(:gt) { str('>') }
    rule(:gteq) { str('>=') }

    # Operators
    rule(:and_operator) { str('&&') }
    rule(:or_operator) { str('||') }

    # Operand
    rule(:identifier) { match('[a-zA-Z0-9\-_]').repeat(1) }
    
    # Grammar
    rule(:compare_eq) { (identifier.as(:left) >> space? >> eq >> space? >> identifier.as(:right)).as(:eq) }
    rule(:compare_not_eq) { (identifier.as(:left) >> space? >> not_eq >> space? >> identifier.as(:right)).as(:not_eq) }
    rule(:compare_lt) { (identifier.as(:left) >> space? >> lt >> space? >> identifier.as(:right)).as(:lt) }
    rule(:compare_lteq) { (identifier.as(:left) >> space? >> lteq >> space? >> identifier.as(:right)).as(:lteq) }
    rule(:compare_gt) { (identifier.as(:left) >> space? >> gt >> space? >> identifier.as(:right)).as(:gt) }
    rule(:compare_gteq) { (identifier.as(:left) >> space? >> gteq >> space? >> identifier.as(:right)).as(:gteq) }
   
    rule(:compare) { compare_eq | compare_not_eq | compare_lteq | compare_lt | compare_gteq | compare_gt }

    rule(:primary) { left_parenthesis >> space? >> or_operation >> space? >> right_parenthesis | compare }
    rule(:and_operation) { (primary.as(:left) >> space? >> and_operator >> space? >> and_operation.as(:right)).as(:and) | primary }
    rule(:or_operation) { (and_operation.as(:left) >> space? >> or_operator >> space? >> or_operation.as(:right)).as(:or) | and_operation }
    
    root :or_operation
  end
end
