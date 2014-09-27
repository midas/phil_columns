require 'pathname'

module PhilColumns
  module Command
    class Mulligan < Base

      def execute
        load_environment

        say( "- DRY RUN -", :yellow ) if dry_run?

        unless dry_run?
          migrator.mulligan
          archivist.clear_seeds
        end

        seeder.execute
      end

    end
  end
end
