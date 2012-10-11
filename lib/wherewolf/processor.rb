module Wherewolf
  class Processor
  protected
    def check_column!(value, table)
      unless table.columns.map(&:name).include?(value.to_sym)
        source = Parslet::Source.new(value.to_s)
        cause = Parslet::Cause.new('Column not found', source, value.offset, [])
        raise Parslet::ParseFailed.new('Column not found', cause) 
      end
    end
  end
end
