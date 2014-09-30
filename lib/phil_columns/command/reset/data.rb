require 'pathname'

module PhilColumns
  module Command
    module Reset
      class Data < Base

        def execute
          load_environment
          purger.purge
          seeder.execute
        end

      protected

        def purger
          @purger ||= PhilColumns::Purger.new( config )
        end

      end
    end
  end
end
