require File.join(File.dirname(__FILE__), 'wherewolf', 'parser.rb')
require File.join(File.dirname(__FILE__), 'wherewolf', 'processor.rb')

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
    def from_query(query)
      Wherewolf::Processor.parse(self, query)
    end
  end
end

require File.join(File.dirname(__FILE__), 'wherewolf', 'railtie.rb') if defined?(Rails::Railtie)
