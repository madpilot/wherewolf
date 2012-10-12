require 'arel'

module Wherewolf
  module Where
    class Processor < Wherewolf::Processor
      def self.parse(model, query)
        instance = self.new(model, model.wherewolf_options)
        instance.parse(query)
      end

      def parse(query)
        begin
          ast = Wherewolf::Where::Parser.new.parse(query)
          table = model.arel_table
          self.model.where(process(ast, table))
        rescue Parslet::ParseFailed => error
          raise Wherewolf::ParseError, error
        end
      end

      def process(ast, table)
        operation = ast.keys.first
        self.send("process_#{operation}".to_sym, ast[operation], table) if self.respond_to?("process_#{operation}".to_sym)
      end

  protected
      def process_and(ast, table)
        process(ast[:left], table).and(process(ast[:right], table))     
      end

      def process_or(ast, table)
        process(ast[:left], table).or(process(ast[:right], table))     
      end

      def process_eq(ast, table)
        check_column!(ast[:left], table)
        table[ast[:left].to_sym].eq(parse_value(ast[:right]))
      end

      def process_not_eq(ast, table)
        check_column!(ast[:left], table)
        table[ast[:left].to_sym].not_eq(parse_value(ast[:right]))
      end

      def process_matches(ast, table)
        check_column!(ast[:left], table)
        table[ast[:left].to_sym].matches(parse_value(ast[:right]))
      end

      def process_lt(ast, table)
        check_column!(ast[:left], table)
        table[ast[:left].to_sym].lt(parse_value(ast[:right]))
      end

      def process_lteq(ast, table)
        check_column!(ast[:left], table)
        table[ast[:left].to_sym].lteq(parse_value(ast[:right]))
      end

      def process_gt(ast, table)
        check_column!(ast[:left], table)
        table[ast[:left].to_sym].gt(parse_value(ast[:right]))
      end

      def process_gteq(ast, table)
        check_column!(ast[:left], table)
        table[ast[:left].to_sym].gteq(parse_value(ast[:right]))
      end

      def parse_value(value)
        type = value.keys.first
        case type
        when :nil
          return nil
        when :boolean
          return value[:boolean] == "true"
        else
          return value[type].to_s
        end
      end
    end
  end
end
