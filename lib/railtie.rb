module PhilColumns
  if defined? Rails::Railtie
    require 'rails'

    class Railtie < Rails::Railtie

      # initializer 'phil_columns.insert_into_active_record' do
      #   ActiveSupport.on_load :active_record do
      #     PhilColumns::Railtie.insert
      #   end
      # end

      rake_tasks do
        load "tasks/phil_columns.rake"
      end

    end

  end

  class Railtie

    def self.insert

    end

  end

end
