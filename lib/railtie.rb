module Wherewolf
  class Railtie < Rails::Railtie
    initializer 'wherewolf.initialize' do
      ActiveSupport.on_load(:active_record) do
        ActiveRecord::Base.send :included, Wherewolf
      end
    end
  end
end
