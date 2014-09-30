module PhilColumns
  class Purger

    include PhilColumns::Output

    def initialize( config )
      @config = config
    end

    def purge
      tables.each do |table|
        if config.skip &&
            config.skip_tables_on_purge.include?( table )
          say "Skipping #{table}", :yellow
          next
        end

        confirm "Purging #{table} ... " do
          klass = table.classify.constantize
          klass.delete_all
        end
      end

      archivist.clear_seeds
    end

  protected

    attr_reader :config

    def tables
      migrator.tables.sort
    end

    def archivist
      @archivist ||= PhilColumns::Archivist.new
    end

    def migrator
      @migrator ||= PhilColumns::Migrator.new( config )
    end

  end
end
