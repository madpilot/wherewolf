require 'arel'

module Wherewolf
  class Processor
    def self.parse(model, query)
      instance = self.new
      instance.parse(model, query)
    end

    def parse(model, query)
      ast = Wherewolf::Parser.new.parse(query)
      table = Arel::Table.new(model.table_name)
      table.where(process(ast, table))
    end

    def process(ast, table)
      operation = ast.keys.first
      self.send("process_#{operation}".to_sym, ast[operation], table) if self.respond_to?("process_#{operation}".to_sym)
    end

    def process_and(ast, table)
      process(ast[:left], table).and(process(ast[:right], table))     
    end

    def process_or(ast, table)
      process(ast[:left], table).or(process(ast[:right], table))     
    end

    def process_eq(ast, table)
      table[ast[:left].eq(ast[:right])
    end

    def process_noteq(ast, table)
      table[ast[:left].not_eq(ast[:right])
    end

    def process_lt(ast, table)
      table[ast[:left].lt(ast[:right])
    end

    def process_lteq(ast, table)
      table[ast[:left].lteq(ast[:right])
    end

    def process_gt(ast, table)
      table[ast[:left].gt(ast[:right])
    end

    def process_gteq(ast, table)
      table[ast[:left].gteq(ast[:right])
    end
  end
end
