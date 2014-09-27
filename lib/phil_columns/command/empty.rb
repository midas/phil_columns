module PhilColumns
  module Command
    class Empty < Base

      def execute
        load_environment

        table_classes.each do |klass|
          confirm "Deleting from #{klass.name.tableize} ... " do
            klass.delete_all
          end
        end

        archivist.clear_seeds
        migrator.clear_migrations_table
      end

    protected

      def table_classes
        tables.map { |t| t.classify.constantize }
      end

      def tables
        migrator.tables.sort
      end

    end
  end
end
