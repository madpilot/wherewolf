module Wherewolf
  class ParseError < Parslet::ParseFailed
    attr_reader :parent
    def initialize(parent)
      @parent = parent
    end

    def position
      parent.cause.source.pos
    end

    def error_message
      "Parsing error occured at character #{position}"
    end

    def to_s
      error_message
    end
  end
end
