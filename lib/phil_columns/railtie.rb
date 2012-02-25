module Paperclip
  if defined? Rails::Railtie
    require 'rails'

    class Railtie < Rails::Railtie

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
