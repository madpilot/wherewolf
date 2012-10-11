require File.join(File.dirname(__FILE__), 'wherewolf', 'where', 'parser.rb')
require File.join(File.dirname(__FILE__), 'wherewolf', 'where', 'processor.rb')
require File.join(File.dirname(__FILE__), 'wherewolf', 'parse_error.rb')

module Wherewolf
  def self.included(base)
    base.send :extend, ClassMethods
  end
  
  module ClassMethods
    def has_query_parsing(options = {})
      self.extend QueryMethods
    end
  end

  module QueryMethods
    def where_query(query)
      Wherewolf::Where::Processor.parse(self, query)
    end

    def order_query(query)
      Wherewold::Order::Processor.parse(self, query)
    end
  end
end

require File.join(File.dirname(__FILE__), 'wherewolf', 'railtie.rb') if defined?(Rails::Railtie)
