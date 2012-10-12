require File.join(File.dirname(__FILE__), 'wherewolf', 'processor.rb')
require File.join(File.dirname(__FILE__), 'wherewolf', 'where', 'parser.rb')
require File.join(File.dirname(__FILE__), 'wherewolf', 'where', 'processor.rb')
require File.join(File.dirname(__FILE__), 'wherewolf', 'order', 'parser.rb')
require File.join(File.dirname(__FILE__), 'wherewolf', 'order', 'processor.rb')
require File.join(File.dirname(__FILE__), 'wherewolf', 'parse_error.rb')

module Wherewolf
  def self.included(base)
    base.send :extend, ClassMethods
  end
  
  module ClassMethods
    def has_query_parsing(options = {})
      self.class_eval do
        scope :where_query, lambda { |query| Wherewolf::Where::Processor.parse(self, query) }
        scope :order_query, lambda { |query| Wherewolf::Order::Processor.parse(self, query) }
      end
    end
  end
end

require File.join(File.dirname(__FILE__), 'wherewolf', 'railtie.rb') if defined?(Rails::Railtie)
