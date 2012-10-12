require 'arel'

module Wherewolf
  module Order
    class Processor < Wherewolf::Processor
      def self.parse(model, query)
        instance = self.new(model, model.wherewolf_options)
        instance.parse(query)
      end

      def parse(query)
        begin
          ast = Wherewolf::Order::Parser.new.parse(query)
          process(ast)
        rescue Parslet::ParseFailed => error
          raise Wherewolf::ParseError, error
        end
      end

      def process(ast)
        ast = [ast] unless ast.is_a?(Array)
        table = self.model.arel_table
        model = self.model
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
