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
    rule(:matches) { str('~=') }
    rule(:lt) { str('<') }
    rule(:lteq) { str('<=') }
    rule(:gt) { str('>') }
    rule(:gteq) { str('>=') }

    # Operators
    rule(:and_operator) { str('&&') }
    rule(:or_operator) { str('||') }

    # Operand
    rule(:null) { str("null").as(:nil) }
    rule(:boolean) { str("true").as(:boolean) | str("false").as(:boolean) }
    rule(:number) { match('[-+]?([0-9]*\.)?[0-9]').repeat(1).as(:number) }
    rule(:double_quote_string) do
      str('"') >>
      (
        (str('\\') >> any) |
        (str('"').absent? >> any)
      ).repeat.as(:string) >>
      str('"')
    end
    rule(:literal) { match('[a-zA-Z0-9\-_]').repeat(1) }
    rule(:identifier) { null | boolean | number | double_quote_string | literal.as(:string) }
    
    # Grammar
    rule(:compare_eq) { (literal.as(:left) >> space? >> eq >> space? >> identifier.as(:right)).as(:eq) }
    rule(:compare_not_eq) { (literal.as(:left) >> space? >> not_eq >> space? >> identifier.as(:right)).as(:not_eq) }
    rule(:compare_matches) { (literal.as(:left) >> space? >> matches >> space? >> identifier.as(:right)).as(:matches) }
    rule(:compare_lt) { (literal.as(:left) >> space? >> lt >> space? >> identifier.as(:right)).as(:lt) }
    rule(:compare_lteq) { (literal.as(:left) >> space? >> lteq >> space? >> identifier.as(:right)).as(:lteq) }
    rule(:compare_gt) { (literal.as(:left) >> space? >> gt >> space? >> identifier.as(:right)).as(:gt) }
    rule(:compare_gteq) { (literal.as(:left) >> space? >> gteq >> space? >> identifier.as(:right)).as(:gteq) }
   
    rule(:compare) { compare_eq | compare_not_eq | compare_matches | compare_lteq | compare_lt | compare_gteq | compare_gt }

    rule(:primary) { left_parenthesis >> space? >> or_operation >> space? >> right_parenthesis | compare }
    rule(:and_operation) { (primary.as(:left) >> space? >> and_operator >> space? >> and_operation.as(:right)).as(:and) | primary }
    rule(:or_operation) { (and_operation.as(:left) >> space? >> or_operator >> space? >> or_operation.as(:right)).as(:or) | and_operation }
    
    root :or_operation
  end
end
