require File.join(File.dirname(__FILE__), 'wherewolf', 'parser.rb')
require File.join(File.dirname(__FILE__), 'wherewolf', 'processor.rb')
require File.join(File.dirname(__FILE__), 'wherewold', 'railtie.rb') if defined?(Rails)

module Wherewolf
  VERSION = '0.0.1'

  def self.included(base)
    base.send :extend, ClassMethods
  end
  
  module ClassMethods
    def has_query_parsing(options = {})

    end
    
    def from_query(query)
      Wherewolf::Processor.parse(self, query)
    end
  end
end
