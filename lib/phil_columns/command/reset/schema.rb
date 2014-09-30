require 'pathname'

module PhilColumns
  module Command
    module Reset
      class Schema < Base

        def execute
          load_environment
          migrator.mulligan
          archivist.clear_seeds
        end

      protected

        def migrator
          @migrator ||= PhilColumns::Migrator.new( config.merge( schema_load_strategy: 'migrate' ))
        end

      end
    end
  end
end
