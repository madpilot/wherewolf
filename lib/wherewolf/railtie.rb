module Wherewolf
  class Railtie < Rails::Railtie
    initializer 'wherewolf' do |app|
      ActiveSupport.on_load :active_record do
        ActiveRecord::Base.send :include, Wherewolf
      end
    end
  end
end
