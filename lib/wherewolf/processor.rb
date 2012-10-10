require 'arel'

module Wherewolf
  class Processor
    def self.parse(model, query)
      instance = self.new
      instance.parse(model, query)
    end

    def parse(model, query)
      begin
        ast = Wherewolf::Parser.new.parse(query)
        table = model.arel_table
        model.where(process(ast, table))
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
      table[ast[:left].to_sym].eq(parse_value(ast[:right]))
    end

    def process_not_eq(ast, table)
      table[ast[:left].to_sym].not_eq(parse_value(ast[:right]))
    end

    def process_matches(ast, table)
      table[ast[:left].to_sym].matches(parse_value(ast[:right]))
    end

    def process_lt(ast, table)
      table[ast[:left].to_sym].lt(parse_value(ast[:right]))
    end

    def process_lteq(ast, table)
      table[ast[:left].to_sym].lteq(parse_value(ast[:right]))
    end

    def process_gt(ast, table)
      table[ast[:left].to_sym].gt(parse_value(ast[:right]))
    end

    def process_gteq(ast, table)
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
