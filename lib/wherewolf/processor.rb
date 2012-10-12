module Wherewolf
  class Processor
    attr_accessor :model
    def initialize(model, options = {})
      @model = model
      @options = options
    end
  protected
    def check_column!(value, table)
      unless columns(table).include?(value.to_sym)
        source = Parslet::Source.new(value.to_s)
        cause = Parslet::Cause.new('Column not found', source, value.offset, [])
        raise Parslet::ParseFailed.new('Column not found', cause) 
      end
    end

    def columns(table)
      columns = table.columns.map(&:name)
      columns = columns & whitelist if whitelist
      columns -= blacklist if blacklist
      columns
    end

    def whitelist
      return @options[:whitelist].call(self.model) if @options[:whitelist].is_a?(Proc)
      return @options[:whitelist] if @options[:whitelist]
      return nil
    end

    def blacklist
      return @options[:blacklist].call(self.model) if @options[:blacklist].is_a?(Proc)
      return @options[:blacklist] if @options[:blacklist]
      return nil
    end
  end
end
