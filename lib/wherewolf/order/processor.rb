require 'arel'

module Wherewolf
  module Order
    class Processor < Wherewolf::Processor
      def self.parse(model, query)
        instance = self.new
        instance.parse(model, query)
      end

      def parse(model, query)
        begin
          ast = Wherewolf::Order::Parser.new.parse(query)
          process(ast, model)
        rescue Parslet::ParseFailed => error
          raise Wherewolf::ParseError, error
        end
      end

      def process(ast, model)
        ast = [ast] unless ast.is_a?(Array)
        table = model.arel_table
        ast.each do |order|
          check_column!(order[:column], table)
          direction = (order[:direction] || 'asc').to_sym
          model = model.order(table[order[:column].to_sym].send(direction))
        end
        model
      end
    end
  end
end
