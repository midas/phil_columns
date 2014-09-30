module PhilColumns
  module Command
    class Empty < Base

      def execute
        load_environment

        tables.each do |table|
          if config.skip &&
              config.skip_tables_on_empty.include?( table )
            say "Skipping #{table}", :yellow
            next
          end

          confirm "Emptying #{table} ... " do
            klass = table.classify.constantize
            klass.delete_all
          end
        end

        archivist.clear_seeds
        migrator.clear_migrations_table
      end

    protected

      def tables
        migrator.tables.sort
      end

    end
  end
end
